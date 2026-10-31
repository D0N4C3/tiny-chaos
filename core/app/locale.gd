class_name Locale
extends RefCounted
## Loads generated translations (tools/build_localization.py -> content/localization/strings.csv)
## and applies the player's language. Missing locales or keys fall back to English.

const SUPPORTED: PackedStringArray = ["en", "es", "pt_BR", "fr", "it"]
const FALLBACK: String = "en"
const TRANSLATION_PATH: String = "res://content/localization/strings.%s.translation"

static var _installed: bool = false


## Registers every generated translation that exists (untranslated locales have no file yet).
static func install_translations() -> PackedStringArray:
	var loaded: PackedStringArray = PackedStringArray()
	for code: String in SUPPORTED:
		var path: String = TRANSLATION_PATH % code
		if not ResourceLoader.exists(path):
			continue
		var translation: Translation = load(path) as Translation
		if translation != null:
			TranslationServer.add_translation(translation)
			loaded.append(code)
	_installed = true
	return loaded


## Applies a supported locale code; anything else falls back to English. Returns the applied code.
static func apply(code: String) -> String:
	if not _installed:
		install_translations()
	var applied: String = code if SUPPORTED.has(code) else FALLBACK
	TranslationServer.set_locale(applied)
	return applied
