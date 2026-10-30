class_name MotionPrefs
extends RefCounted
## Reduced-motion hooks. Reduced motion disables shake, parallax, flashes and nonessential
## particles; informative animation keeps playing (shortened via scaled_duration).

const REDUCED_DURATION_SCALE: float = 0.35

## Tests inject {"reduced_motion": bool, "camera_shake": bool}; empty = read SaveManager.
static var override_settings: Dictionary = {}


static func reduced() -> bool:
	return bool(_setting("reduced_motion", false))


static func shake_enabled() -> bool:
	return bool(_setting("camera_shake", true)) and not reduced()


static func flashes_enabled() -> bool:
	return not reduced()


static func parallax_enabled() -> bool:
	return not reduced()


## essential=true for particles that carry gameplay information (e.g. a goal sensor cue).
static func particles_enabled(essential: bool = false) -> bool:
	return essential or not reduced()


## Duration for decorative/celebration animation; informative animation passes essential=true.
static func scaled_duration(seconds: float, essential: bool = false) -> float:
	if essential or not reduced():
		return seconds
	return seconds * REDUCED_DURATION_SCALE


static func _setting(key: String, fallback: Variant) -> Variant:
	if override_settings.has(key):
		return override_settings[key]
	var tree: SceneTree = Engine.get_main_loop() as SceneTree
	var save: Node = tree.root.get_node_or_null("SaveManager") if tree != null else null
	if save == null:
		return fallback
	return save.call("get_setting", key)
