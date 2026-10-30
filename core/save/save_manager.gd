extends Node
## Autoload `SaveManager`: versioned local profile with atomic writes, backups, migration and
## downgrade protection. Offline only; never stores personal data or purchase tokens.
## Write order: profile.json.tmp (verified) -> profile.json moved to profile.bak.json -> tmp renamed.

enum LoadStatus { NEW_PROFILE, LOADED, RECOVERED_FROM_TMP, RECOVERED_FROM_BACKUP, RESET_AFTER_CORRUPTION, NEWER_VERSION_READ_ONLY }

signal loaded(status: LoadStatus)
signal saved()
signal save_failed(error: Error)

const FILE_NAME: String = "profile.json"

## Directory for the profile; tests point this at an isolated folder before calling load_profile().
var save_dir: String = "user://save"
## Overridable for migration tests; production uses SaveSchema values.
var target_version: int = SaveSchema.CURRENT_VERSION
var migrations: Dictionary = SaveSchema.migrations()
## When true, load_profile() runs from _ready(). Tests disable it.
var autoload_on_ready: bool = true

var data: Dictionary = {}
var load_status: LoadStatus = LoadStatus.NEW_PROFILE
## True when the profile was written by a newer build: nothing is written so it can't be clobbered.
var read_only: bool = false
var is_first_open: bool = false

var _dirty: bool = false
var _save_queued: bool = false


func _ready() -> void:
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.connect("setting_changed", _on_setting_changed)
	# The headless test runner passes --test-run so the real player profile is never touched.
	if autoload_on_ready and not OS.get_cmdline_user_args().has("--test-run"):
		load_profile()


func main_path() -> String:
	return save_dir.path_join(FILE_NAME)


func load_profile() -> LoadStatus:
	DirAccess.make_dir_recursive_absolute(save_dir)
	read_only = false
	var main: String = main_path()
	var candidates: Array[Array] = [
		[main, LoadStatus.LOADED],
		[main + ".tmp", LoadStatus.RECOVERED_FROM_TMP],
		[save_dir.path_join("profile.bak.json"), LoadStatus.RECOVERED_FROM_BACKUP],
	]
	var any_file_exists: bool = false
	for candidate: Array in candidates:
		var path: String = candidate[0]
		if not FileAccess.file_exists(path):
			continue
		any_file_exists = true
		var envelope: Dictionary = _read_envelope(path)
		if envelope.is_empty():
			continue
		var version: int = int(envelope["schema_version"])
		if version > target_version:
			data = SaveSchema.defaults()
			read_only = true
			return _finish_load(LoadStatus.NEWER_VERSION_READ_ONLY)
		var payload: Dictionary = envelope["data"]
		if version < target_version:
			_backup_before_migration(path, version)
			payload = _migrate(payload, version)
		data = SaveSchema.normalize(payload)
		var status: LoadStatus = candidate[1]
		if status != LoadStatus.LOADED:
			# Keep the unreadable main file for diagnosis; don't rotate it over a good backup.
			_quarantine(main)
		if status != LoadStatus.LOADED or version < target_version:
			save_now()
		return _finish_load(status)
	data = SaveSchema.defaults()
	data["install_id"] = _random_id()
	if any_file_exists:
		for candidate: Array in candidates:
			_quarantine(candidate[0])
		save_now()
		return _finish_load(LoadStatus.RESET_AFTER_CORRUPTION)
	is_first_open = true
	save_now()
	return _finish_load(LoadStatus.NEW_PROFILE)


## Writes immediately. Use before showing results or ads (spec: persist clears first).
func save_now() -> Error:
	_save_queued = false
	if read_only:
		return ERR_FILE_NO_PERMISSION
	if str(data.get("install_id", "")).is_empty():
		data["install_id"] = _random_id()
	var error: Error = _atomic_write(main_path(), _make_envelope(data))
	if error == OK:
		_dirty = false
		saved.emit()
	else:
		push_error("SaveManager write failed: %s" % error_string(error))
		save_failed.emit(error)
	return error


## Coalesces several changes in one frame into one write.
func request_save() -> void:
	_dirty = true
	if not _save_queued:
		_save_queued = true
		save_now.call_deferred()


func get_setting(key: String) -> Variant:
	return (data.get("settings", {}) as Dictionary).get(key, SaveSchema.SETTING_DEFAULTS.get(key))


func set_setting(key: String, value: Variant) -> bool:
	var clean: Variant = SaveSchema.sanitize_setting(key, value)
	if clean == null:
		push_warning("SaveManager rejected setting %s=%s" % [key, value])
		return false
	(data["settings"] as Dictionary)[key] = clean
	request_save()
	return true


func has_claim(claim_key: String) -> bool:
	return (data["reward_claims"] as Array).has(claim_key)


## Idempotent reward: credits amount once per claim_key (e.g. "main:W01_L001:clear") and saves
## immediately. Returns false when already claimed or the profile is read-only.
func grant_once(claim_key: String, currency_id: StringName, amount: int) -> bool:
	if read_only or has_claim(claim_key) or amount < 0:
		return false
	var wallet: Dictionary = data["wallet"]
	var balance: int = int(wallet.get(String(currency_id), 0)) + amount
	wallet[String(currency_id)] = balance
	(data["reward_claims"] as Array).append(claim_key)
	if save_now() != OK:
		return false
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.call("emit_currency_changed", currency_id, balance, amount)
	return true


## Records a main-level clear, keeping the best result across replays, and saves immediately.
func record_level_result(level_id: String, medals: PackedStringArray, actions: int) -> void:
	var results: Dictionary = data["level_results"]
	var entry: Dictionary = results.get(level_id, {"cleared": false, "medals": [], "best_actions": 0})
	entry["cleared"] = true
	var known: Array = entry["medals"]
	for medal: String in medals:
		if not known.has(medal):
			known.append(medal)
	var best: int = int(entry["best_actions"])
	entry["best_actions"] = actions if best <= 0 else mini(best, actions)
	results[level_id] = entry
	save_now()


## Resets progress sections; settings, privacy choices and install id are kept.
func delete_local_progress() -> Error:
	var fresh: Dictionary = SaveSchema.defaults()
	for section: String in SaveSchema.PROGRESS_SECTIONS:
		data[section] = fresh[section]
	return save_now()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		if _dirty:
			save_now()


func _on_setting_changed(key: StringName, value: Variant) -> void:
	set_setting(String(key), value)


func _finish_load(status: LoadStatus) -> LoadStatus:
	load_status = status
	_dirty = false
	loaded.emit(status)
	return status


func _make_envelope(payload: Dictionary) -> Dictionary:
	return {
		"format": SaveSchema.FORMAT_ID,
		"schema_version": target_version,
		"saved_at_utc": Time.get_datetime_string_from_system(true),
		"checksum": _checksum(payload),
		"data": payload,
	}


## Returns {} when the file is unreadable, not a profile, or fails its checksum.
func _read_envelope(path: String) -> Dictionary:
	var text: String = FileAccess.get_file_as_string(path)
	if text.is_empty():
		return {}
	var parsed: Variant = JSON.parse_string(text)
	if not parsed is Dictionary:
		return {}
	var envelope: Dictionary = parsed
	if envelope.get("format") != SaveSchema.FORMAT_ID or not envelope.get("data") is Dictionary:
		return {}
	if not (envelope.get("schema_version") is float or envelope.get("schema_version") is int):
		return {}
	if envelope.get("checksum") != _checksum(envelope["data"]):
		return {}
	return envelope


## Hashes the JSON round-tripped form so ints (written) and floats (parsed back) hash equally.
func _checksum(payload: Dictionary) -> String:
	var canonical: Variant = JSON.parse_string(JSON.stringify(payload, "", true))
	return JSON.stringify(canonical, "", true).sha256_text()


func _atomic_write(path: String, envelope: Dictionary) -> Error:
	var tmp_path: String = path + ".tmp"
	var text: String = JSON.stringify(envelope, "\t", true)
	var file: FileAccess = FileAccess.open(tmp_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_string(text)
	file.flush()
	var write_error: Error = file.get_error()
	file.close()
	if write_error != OK:
		return write_error
	if _read_envelope(tmp_path).is_empty():
		return ERR_FILE_CORRUPT
	var backup_path: String = save_dir.path_join("profile.bak.json")
	if FileAccess.file_exists(path):
		if FileAccess.file_exists(backup_path):
			DirAccess.remove_absolute(backup_path)
		var backup_error: Error = DirAccess.rename_absolute(path, backup_path)
		if backup_error != OK:
			return backup_error
	return DirAccess.rename_absolute(tmp_path, path)


func _migrate(payload: Dictionary, from_version: int) -> Dictionary:
	var result: Dictionary = payload.duplicate(true)
	for version: int in range(from_version, target_version):
		var step: Callable = migrations.get(version, Callable())
		if step.is_valid():
			result = step.call(result)
	return result


func _backup_before_migration(path: String, version: int) -> void:
	var backup: String = save_dir.path_join("profile.v%d.bak.json" % version)
	if not FileAccess.file_exists(backup):
		DirAccess.copy_absolute(path, backup)


## Moves an unreadable profile file aside as corrupt_<unix_ms>_<name> instead of deleting it.
func _quarantine(path: String) -> void:
	if not FileAccess.file_exists(path):
		return
	var stamp: int = int(Time.get_unix_time_from_system() * 1000.0)
	DirAccess.rename_absolute(path, save_dir.path_join("corrupt_%d_%s" % [stamp, path.get_file()]))


func _random_id() -> String:
	return Crypto.new().generate_random_bytes(16).hex_encode()
