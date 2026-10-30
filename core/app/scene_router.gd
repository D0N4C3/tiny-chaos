extends Node
## Autoload `SceneRouter`: one active full screen plus a back stack.
## Screens follow docs/architecture/ui_screen_contract.md (ScreenBase); the router duck-types
## that contract so core/ never depends on ui/ or features/.
## Back order (spec 03_UX): screen.handle_back() (modals) -> pop stack -> exit_requested at root.

signal screen_entered(screen_id: StringName, screen: Node)
## Emitted on back at the root screen; the app decides whether to quit.
signal exit_requested()

## screen id -> res:// path or PackedScene. Defaults to ScreenRoutes; tests inject their own.
var routes: Dictionary = ScreenRoutes.ROUTES.duplicate()
## Parent for screens. Defaults to the tree root, where the screen also becomes current_scene.
var host: Node = null
## Android convention: back on the root screen leaves the app. Tests turn this off.
var quit_on_root_back: bool = true
var current_screen: Node = null
var current_screen_id: StringName = &""

var _stack: Array[Dictionary] = []


func has_route(screen_id: StringName) -> bool:
	var target: Variant = routes.get(screen_id)
	if target is PackedScene:
		return true
	return target is String and ResourceLoader.exists(target)


func stack_depth() -> int:
	return _stack.size()


## Shows screen_id. replace=true swaps the top entry; clear_history=true makes it the new root.
func go_to(screen_id: StringName, params: Dictionary = {}, replace: bool = false, clear_history: bool = false) -> bool:
	var screen: Node = _instantiate(screen_id)
	if screen == null:
		return false
	if clear_history:
		_stack.clear()
	elif replace and not _stack.is_empty():
		_stack.pop_back()
	_stack.append({"id": screen_id, "params": params})
	_mount(screen_id, screen, params)
	return true


## Router-level back. Returns false only when the stack is at its root (exit_requested emitted).
func back() -> bool:
	if current_screen != null and current_screen.has_method("handle_back") and current_screen.call("handle_back"):
		return true
	if _stack.size() <= 1:
		exit_requested.emit()
		if quit_on_root_back:
			get_tree().quit()
		return false
	_stack.pop_back()
	var previous: Dictionary = _stack.back()
	var screen: Node = _instantiate(previous["id"])
	if screen == null:
		return true
	_mount(previous["id"], screen, previous["params"])
	return true


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		back()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and current_screen != null:
		get_viewport().set_input_as_handled()
		back()


func _instantiate(screen_id: StringName) -> Node:
	var target: Variant = routes.get(screen_id)
	var scene: PackedScene = target as PackedScene
	if scene == null and target is String and ResourceLoader.exists(target):
		scene = load(target) as PackedScene
	if scene == null:
		_report_error(&"route_missing", screen_id)
		return null
	var screen: Node = scene.instantiate()
	if screen == null:
		_report_error(&"route_instantiate_failed", screen_id)
	return screen


func _mount(screen_id: StringName, screen: Node, params: Dictionary) -> void:
	if screen.has_method("setup"):
		screen.call("setup", params)
	if screen.has_signal("navigate_requested"):
		screen.connect("navigate_requested", _on_navigate_requested)
	if screen.has_signal("back_requested"):
		screen.connect("back_requested", _on_back_requested)
	var parent: Node = host if host != null else get_tree().root
	var previous_id: StringName = current_screen_id
	var previous: Node = current_screen
	if previous == null and parent == get_tree().root:
		previous = get_tree().current_scene
	parent.add_child(screen)
	if parent == get_tree().root:
		get_tree().current_scene = screen
	if previous != null and is_instance_valid(previous):
		previous.queue_free()
	current_screen = screen
	current_screen_id = screen_id
	var app_state: Node = get_node_or_null("/root/AppState")
	if app_state != null:
		app_state.call("enter_screen", screen_id, params)
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.call("emit_screen_changed", screen_id, previous_id)
	screen_entered.emit(screen_id, screen)


func _on_navigate_requested(screen_id: StringName, params: Dictionary) -> void:
	# Navigating "home" from anywhere resets history so back from Home exits.
	go_to(screen_id, params, false, screen_id == &"home")


func _on_back_requested() -> void:
	back()


func _report_error(error_code: StringName, screen_id: StringName) -> void:
	push_error("SceneRouter %s: %s" % [error_code, screen_id])
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.call("emit_runtime_error", error_code, screen_id)
