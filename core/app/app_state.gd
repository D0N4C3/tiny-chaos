extends Node
## Autoload `AppState`: in-memory session state only (no persistence, no unlock rules yet;
## unlock queries will delegate to SaveManager). Updated by SceneRouter and app lifecycle.

enum Phase { BOOTING, MENU, IN_LEVEL }

signal phase_changed(phase: Phase)
signal backgrounded_changed(is_backgrounded: bool)

## Random per-launch id for analytics session grouping; never derived from device identity.
var session_id: String = ""
var phase: Phase = Phase.BOOTING
var current_screen_id: StringName = &""
var current_world_id: StringName = &""
var current_level_id: StringName = &""
var is_backgrounded: bool = false
var session_started_msec: int = 0


func _ready() -> void:
	start_session()
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.connect("setting_changed", _on_setting_changed)
	# SaveManager loads after this autoload; apply the saved language once it is ready.
	_apply_saved_locale.call_deferred()


func start_session() -> void:
	var crypto: Crypto = Crypto.new()
	session_id = crypto.generate_random_bytes(8).hex_encode()
	session_started_msec = Time.get_ticks_msec()
	_set_phase(Phase.BOOTING)


## Called by SceneRouter whenever a screen becomes active.
func enter_screen(screen_id: StringName, params: Dictionary) -> void:
	current_screen_id = screen_id
	if params.has("world_id"):
		current_world_id = StringName(str(params["world_id"]))
	if screen_id == &"level":
		current_level_id = StringName(str(params.get("level_id", "")))
		_set_phase(Phase.IN_LEVEL)
	else:
		current_level_id = &""
		_set_phase(Phase.MENU)


func _apply_saved_locale() -> void:
	var save: Node = get_node_or_null("/root/SaveManager")
	Locale.apply(str(save.call("get_setting", "language")) if save != null else Locale.FALLBACK)


func _on_setting_changed(key: StringName, value: Variant) -> void:
	if key == &"language":
		Locale.apply(str(value))


func session_seconds() -> float:
	return float(Time.get_ticks_msec() - session_started_msec) / 1000.0


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_APPLICATION_FOCUS_OUT:
			_set_backgrounded(true)
		NOTIFICATION_APPLICATION_RESUMED, NOTIFICATION_APPLICATION_FOCUS_IN:
			_set_backgrounded(false)


func _set_backgrounded(value: bool) -> void:
	if is_backgrounded == value:
		return
	is_backgrounded = value
	backgrounded_changed.emit(value)


func _set_phase(value: Phase) -> void:
	if phase == value and value != Phase.BOOTING:
		return
	phase = value
	phase_changed.emit(value)
