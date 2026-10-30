class_name Haptics
extends RefCounted
## Sparse, optional vibration presets (spec: restrained, no long rattles). Gated by the
## "haptics" setting and rate-limited so rapid retries never produce a continuous buzz.

enum Pattern { TAP, TOGGLE, SUCCESS }

## Pattern -> [duration_ms, amplitude 0..1]
const PRESETS: Dictionary = {
	Pattern.TAP: [12, 0.25],
	Pattern.TOGGLE: [18, 0.35],
	Pattern.SUCCESS: [40, 0.6],
}
const MIN_INTERVAL_MSEC: int = 90

## Tests set these to observe output without a device; override_enabled: -1 = read setting.
static var override_enabled: int = -1
static var sink: Callable = Callable()
static var _last_msec: int = -100000


static func play(pattern: Pattern) -> bool:
	if not is_enabled():
		return false
	var now: int = Time.get_ticks_msec()
	if now - _last_msec < MIN_INTERVAL_MSEC:
		return false
	_last_msec = now
	var preset: Array = PRESETS[pattern]
	if sink.is_valid():
		sink.call(int(preset[0]), float(preset[1]))
	else:
		Input.vibrate_handheld(int(preset[0]), float(preset[1]))
	return true


static func is_enabled() -> bool:
	if override_enabled != -1:
		return override_enabled == 1
	var save: Node = _save_manager()
	return save == null or bool(save.call("get_setting", "haptics"))


static func reset_for_tests() -> void:
	override_enabled = -1
	sink = Callable()
	_last_msec = -100000


static func _save_manager() -> Node:
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	return tree.root.get_node_or_null("SaveManager") if tree != null else null
