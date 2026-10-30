extends Node
## Autoload `EventBus`: cross-feature signals with typed emit helpers.
## Listeners connect to the signals; producers call emit_* so argument types are checked.
## Per-level signals (gadget taps, checkpoints) belong to LevelRuntime, not here.

## Why a level ended without a win; values match analytics `failure_cause`.
enum FailCause { OUT_OF_BOUNDS, HAZARD, STUCK, TIMEOUT, BROKEN_TARGET, PLAYER_EXIT }

# Level lifecycle (consumed by save, progression, analytics, monetization).
signal level_started(level_id: StringName, puzzle_type: StringName)
signal level_failed(level_id: StringName, cause: FailCause, retry_count: int)
signal level_rewound(level_id: StringName, checkpoint_id: StringName, rewind_count: int)
signal level_restarted(level_id: StringName, retry_count: int)
## Emitted only after SaveManager has persisted the clear (spec: save before result/ads).
signal level_completed(level_id: StringName, medals: PackedStringArray, metrics: Dictionary)
signal level_exited(level_id: StringName, phase: StringName, elapsed_sec: float)

# Economy and collection.
signal currency_changed(currency_id: StringName, balance: int, delta: int)
signal cosmetic_equipped(cosmetic_id: StringName)
signal invention_unlocked(invention_id: StringName)

# Settings, privacy and entitlements.
signal setting_changed(key: StringName, value: Variant)
signal consent_changed(consent_state: StringName)
signal entitlement_changed(sku: StringName, owned: bool)

# Navigation and diagnostics.
signal screen_changed(screen_id: StringName, previous_screen_id: StringName)
signal runtime_error_reported(error_code: StringName, screen_id: StringName)

const METRIC_KEYS: PackedStringArray = ["seconds", "actions", "retry_count"]


func emit_level_started(level_id: StringName, puzzle_type: StringName) -> void:
	level_started.emit(level_id, puzzle_type)


func emit_level_failed(level_id: StringName, cause: FailCause, retry_count: int) -> void:
	level_failed.emit(level_id, cause, retry_count)


func emit_level_rewound(level_id: StringName, checkpoint_id: StringName, rewind_count: int) -> void:
	level_rewound.emit(level_id, checkpoint_id, rewind_count)


func emit_level_restarted(level_id: StringName, retry_count: int) -> void:
	level_restarted.emit(level_id, retry_count)


## metrics must contain METRIC_KEYS; extra keys are rejected to keep analytics schema-bound.
func emit_level_completed(level_id: StringName, medals: PackedStringArray, metrics: Dictionary) -> void:
	if not _has_exact_keys(metrics, METRIC_KEYS):
		push_error("EventBus.level_completed metrics must have exactly %s, got %s" % [METRIC_KEYS, metrics.keys()])
		return
	level_completed.emit(level_id, medals, metrics)


func emit_level_exited(level_id: StringName, phase: StringName, elapsed_sec: float) -> void:
	level_exited.emit(level_id, phase, elapsed_sec)


func emit_currency_changed(currency_id: StringName, balance: int, delta: int) -> void:
	currency_changed.emit(currency_id, balance, delta)


func emit_cosmetic_equipped(cosmetic_id: StringName) -> void:
	cosmetic_equipped.emit(cosmetic_id)


func emit_invention_unlocked(invention_id: StringName) -> void:
	invention_unlocked.emit(invention_id)


func emit_setting_changed(key: StringName, value: Variant) -> void:
	setting_changed.emit(key, value)


func emit_consent_changed(consent_state: StringName) -> void:
	consent_changed.emit(consent_state)


func emit_entitlement_changed(sku: StringName, owned: bool) -> void:
	entitlement_changed.emit(sku, owned)


func emit_screen_changed(screen_id: StringName, previous_screen_id: StringName) -> void:
	screen_changed.emit(screen_id, previous_screen_id)


func emit_runtime_error(error_code: StringName, screen_id: StringName) -> void:
	runtime_error_reported.emit(error_code, screen_id)


static func fail_cause_name(cause: FailCause) -> StringName:
	return StringName(String(FailCause.keys()[cause]).to_lower())


func _has_exact_keys(data: Dictionary, keys: PackedStringArray) -> bool:
	if data.size() != keys.size():
		return false
	for key: String in keys:
		if not data.has(key):
			return false
	return true
