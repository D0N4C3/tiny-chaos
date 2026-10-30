extends TestCase

const SaveManagerScript: GDScript = preload("res://core/save/save_manager.gd")
const Status = SaveManagerScript.LoadStatus

var _dir: String
var _save: Node


func before_each() -> void:
	_dir = "user://test_saves/%d_%d" % [Time.get_ticks_usec(), randi()]
	DirAccess.make_dir_recursive_absolute(_dir)
	_save = _new_manager()


func after_each() -> void:
	for file: String in DirAccess.get_files_at(_dir):
		DirAccess.remove_absolute(_dir.path_join(file))
	DirAccess.remove_absolute(_dir)


func _new_manager() -> Node:
	var manager: Node = SaveManagerScript.new()
	manager.autoload_on_ready = false
	manager.save_dir = _dir
	return add_node(manager)


func _write(name: String, text: String) -> void:
	var file: FileAccess = FileAccess.open(_dir.path_join(name), FileAccess.WRITE)
	file.store_string(text)
	file.close()


func _envelope_text(manager: Node, payload: Dictionary, version: int) -> String:
	var envelope: Dictionary = manager._make_envelope(payload)
	envelope["schema_version"] = version
	return JSON.stringify(envelope)


func _files_starting(prefix: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	for file: String in DirAccess.get_files_at(_dir):
		if file.begins_with(prefix):
			found.append(file)
	return found


func test_new_profile_is_created_with_defaults_and_install_id() -> void:
	assert_eq(_save.load_profile(), Status.NEW_PROFILE, "status")
	assert_true(_save.is_first_open, "first open")
	assert_eq(str(_save.data["install_id"]).length(), 32, "install id")
	assert_true(FileAccess.file_exists(_save.main_path()), "file written")
	assert_false(FileAccess.file_exists(_save.main_path() + ".tmp"), "no tmp left behind")


func test_round_trip_preserves_progress_and_settings() -> void:
	_save.load_profile()
	_save.record_level_result("W01_L001", PackedStringArray(["rescue"]), 3)
	_save.set_setting("music", 0.3)
	_save.save_now()
	var reloaded: Node = _new_manager()
	assert_eq(reloaded.load_profile(), Status.LOADED, "loaded")
	assert_false(reloaded.is_first_open, "not first open")
	assert_eq(reloaded.data["level_results"]["W01_L001"]["medals"], ["rescue"], "medals")
	assert_eq(reloaded.get_setting("music"), 0.3, "music")
	assert_eq(reloaded.data["install_id"], _save.data["install_id"], "install id stable")


func test_grant_once_is_idempotent_across_reload() -> void:
	_save.load_profile()
	assert_true(_save.grant_once("main:W01_L001:clear", &"screws", 10), "first grant")
	assert_false(_save.grant_once("main:W01_L001:clear", &"screws", 10), "duplicate rejected")
	var reloaded: Node = _new_manager()
	reloaded.load_profile()
	assert_false(reloaded.grant_once("main:W01_L001:clear", &"screws", 10), "still rejected after reload")
	assert_eq(int(reloaded.data["wallet"]["screws"]), 10, "credited once")


func test_replay_keeps_best_actions_and_union_of_medals() -> void:
	_save.load_profile()
	_save.record_level_result("W01_L002", PackedStringArray(["rescue"]), 5)
	_save.record_level_result("W01_L002", PackedStringArray(["efficient"]), 7)
	var entry: Dictionary = _save.data["level_results"]["W01_L002"]
	assert_eq(int(entry["best_actions"]), 5, "best kept")
	assert_eq(entry["medals"], ["rescue", "efficient"], "medals merged")


func test_corrupt_main_recovers_from_backup_and_keeps_evidence() -> void:
	_save.load_profile()
	_save.grant_once("a", &"screws", 5)
	_save.grant_once("b", &"screws", 7)
	_write("profile.json", "{ truncated")
	var reloaded: Node = _new_manager()
	assert_eq(reloaded.load_profile(), Status.RECOVERED_FROM_BACKUP, "status")
	assert_eq(int(reloaded.data["wallet"]["screws"]), 5, "backup has the previous save")
	assert_eq(_files_starting("corrupt_").size(), 1, "corrupt main preserved")
	var again: Node = _new_manager()
	assert_eq(again.load_profile(), Status.LOADED, "recovered profile now loads normally")


func test_checksum_tamper_is_detected() -> void:
	_save.load_profile()
	_save.grant_once("a", &"screws", 5)
	var text: String = FileAccess.get_file_as_string(_save.main_path())
	_write("profile.json", text.replace("\"screws\": 5", "\"screws\": 99999"))
	DirAccess.remove_absolute(_dir.path_join("profile.bak.json"))
	var reloaded: Node = _new_manager()
	assert_eq(reloaded.load_profile(), Status.RESET_AFTER_CORRUPTION, "tampered file rejected")
	assert_eq(int(reloaded.data["wallet"]["screws"]), 0, "fresh wallet")
	assert_eq(_files_starting("corrupt_").size(), 1, "tampered file preserved")


func test_interrupted_write_recovers_from_tmp() -> void:
	_save.load_profile()
	_save.grant_once("a", &"screws", 3)
	var text: String = FileAccess.get_file_as_string(_save.main_path())
	DirAccess.remove_absolute(_save.main_path())
	DirAccess.remove_absolute(_dir.path_join("profile.bak.json"))
	_write("profile.json.tmp", text)
	var reloaded: Node = _new_manager()
	assert_eq(reloaded.load_profile(), Status.RECOVERED_FROM_TMP, "status")
	assert_eq(int(reloaded.data["wallet"]["screws"]), 3, "data from tmp")
	assert_true(FileAccess.file_exists(reloaded.main_path()), "main restored")


func test_migration_backs_up_old_file_and_upgrades() -> void:
	_save.load_profile()
	_save.grant_once("a", &"screws", 4)
	var upgraded: Node = _new_manager()
	upgraded.target_version = 2
	upgraded.migrations = {1: func(old: Dictionary) -> Dictionary:
		old["achievements"] = ["migrated"]
		return old}
	assert_eq(upgraded.load_profile(), Status.LOADED, "loads old version")
	assert_eq(upgraded.data["achievements"], ["migrated"], "migration applied")
	assert_eq(int(upgraded.data["wallet"]["screws"]), 4, "data preserved")
	assert_true(FileAccess.file_exists(_dir.path_join("profile.v1.bak.json")), "pre-migration backup")
	var envelope: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(upgraded.main_path()))
	assert_eq(int(envelope["schema_version"]), 2, "rewritten at new version")


func test_newer_save_is_read_only_and_untouched() -> void:
	_write("profile.json", _envelope_text(_save, {"wallet": {"screws": 42}}, 99))
	var before: String = FileAccess.get_file_as_string(_save.main_path())
	assert_eq(_save.load_profile(), Status.NEWER_VERSION_READ_ONLY, "status")
	assert_true(_save.read_only, "read only")
	assert_eq(_save.save_now(), ERR_FILE_NO_PERMISSION, "writes refused")
	assert_false(_save.grant_once("x", &"screws", 1), "grants refused")
	assert_eq(FileAccess.get_file_as_string(_save.main_path()), before, "file untouched")


func test_settings_are_validated() -> void:
	_save.load_profile()
	assert_false(_save.set_setting("language", "xx"), "unsupported language")
	assert_false(_save.set_setting("haptics", "yes"), "wrong type")
	assert_false(_save.set_setting("unknown", 1), "unknown key")
	assert_true(_save.set_setting("sfx", 2.5), "float accepted")
	assert_eq(_save.get_setting("sfx"), 1.0, "clamped to 0..1")
	assert_true(_save.set_setting("language", "pt_BR"), "supported language")


func test_delete_local_progress_keeps_settings() -> void:
	_save.load_profile()
	var install_id: String = _save.data["install_id"]
	_save.set_setting("haptics", false)
	_save.grant_once("a", &"screws", 9)
	_save.delete_local_progress()
	assert_eq(int(_save.data["wallet"]["screws"]), 0, "wallet reset")
	assert_eq((_save.data["reward_claims"] as Array).size(), 0, "claims reset")
	assert_eq(_save.get_setting("haptics"), false, "settings kept")
	assert_eq(_save.data["install_id"], install_id, "install id kept")
