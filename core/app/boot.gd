class_name Boot
extends Control
## Main scene entry point: shows the splash, then hands navigation to SceneRouter.

signal boot_completed(engine_version: String)

@onready var _version_label: Label = %VersionLabel


func _ready() -> void:
	var engine_version: String = Engine.get_version_info().get("string", "unknown")
	var app_version: String = ProjectSettings.get_setting("application/config/version", "0.0.0")
	_version_label.text = "v%s · Godot %s" % [app_version, engine_version]
	print("[boot] ready app=%s engine=%s renderer=%s" % [
		app_version,
		engine_version,
		RenderingServer.get_current_rendering_method(),
	])
	boot_completed.emit(engine_version)
	if SceneRouter.has_route(&"home"):
		SceneRouter.go_to.call_deferred(&"home", {}, false, true)
	else:
		print("[boot] home route not built yet; staying on boot screen")
