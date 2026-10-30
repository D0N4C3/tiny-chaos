class_name SaveSchema
extends RefCounted
## Save schema v1 defaults, settings validation and version migrations.
## Spec: docs/spec/02_TECH/04_SAVE_CONFIG_AND_PRIVACY.md

const FORMAT_ID: String = "tiny_chaos_save"
const CURRENT_VERSION: int = 1

## Allowed settings and their default values; types are enforced on write and load.
const SETTING_DEFAULTS: Dictionary = {
	"language": "en",
	"sfx": 1.0,
	"music": 0.65,
	"haptics": true,
	"reduced_motion": false,
	"assistive_timing": false,
	"camera_shake": true,
	"symbol_mode": false,
	"larger_controls": false,
}
const LANGUAGES: PackedStringArray = ["en", "es", "pt_BR", "fr", "it"]

## Sections that "Delete local progress" resets (settings/privacy/install id survive).
const PROGRESS_SECTIONS: PackedStringArray = [
	"world_progress", "level_results", "wallet", "reward_claims", "workshop", "dailies", "weekly_events",
]


static func defaults() -> Dictionary:
	return {
		"install_id": "",
		"world_progress": {"W01": {"unlocked": true, "highest_reached": 1}},
		"level_results": {},
		"wallet": {"screws": 0},
		"reward_claims": [],
		"workshop": {"unlocked_items": [], "equipped_theme": "base"},
		"dailies": {},
		"weekly_events": {},
		"settings": SETTING_DEFAULTS.duplicate(true),
		"iap_cache": {"remove_interstitials": false, "verified_at_utc": ""},
		"privacy": {"consent_choice_cached": "unknown", "settings_last_viewed": ""},
	}


## Returns the value coerced to the setting's type, or null when the key/value is not allowed.
static func sanitize_setting(key: String, value: Variant) -> Variant:
	if not SETTING_DEFAULTS.has(key):
		return null
	var default_value: Variant = SETTING_DEFAULTS[key]
	match typeof(default_value):
		TYPE_BOOL:
			return value if value is bool else null
		TYPE_FLOAT:
			if value is float or value is int:
				return clampf(float(value), 0.0, 1.0)
			return null
		TYPE_STRING:
			if key == "language":
				return value if value is String and LANGUAGES.has(value) else null
			return value if value is String else null
	return null


## Fills missing keys from defaults and drops invalid settings, keeping unknown sections intact.
static func normalize(data: Dictionary) -> Dictionary:
	var result: Dictionary = defaults()
	for key: String in data.keys():
		if key == "settings" and data[key] is Dictionary:
			var settings: Dictionary = result["settings"]
			for setting_key: String in (data[key] as Dictionary).keys():
				var clean: Variant = sanitize_setting(setting_key, data[key][setting_key])
				if clean != null:
					settings[setting_key] = clean
		elif result.has(key) and typeof(result[key]) != typeof(data[key]):
			continue
		else:
			result[key] = data[key]
	return result


## version -> Callable(data: Dictionary) -> Dictionary that upgrades data from version to version+1.
static func migrations() -> Dictionary:
	return {}
