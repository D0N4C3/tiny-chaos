extends TestCase

const RouterScript: GDScript = preload("res://core/app/scene_router.gd")
const AppStateScript: GDScript = preload("res://core/app/app_state.gd")

## Minimal in-memory implementation of the ScreenBase contract.
const FAKE_SCREEN_SOURCE: String = """
extends Control
signal navigate_requested(screen_id: StringName, params: Dictionary)
signal back_requested()
var received_params: Dictionary = {}
var modal_open: bool = false
func setup(params: Dictionary) -> void:
	received_params = params
func handle_back() -> bool:
	if modal_open:
		modal_open = false
		return true
	return false
"""

var _router: Node
var _host: Node
var _exits: int = 0


func before_each() -> void:
	_host = add_node(Control.new())
	_router = add_node(RouterScript.new())
	_router.host = _host
	_router.quit_on_root_back = false
	_router.routes = {&"home": _fake_scene(), &"world_select": _fake_scene(), &"level_select": _fake_scene()}
	_router.exit_requested.connect(func() -> void: _exits += 1)
	_exits = 0


func _fake_scene() -> PackedScene:
	var script: GDScript = GDScript.new()
	script.source_code = FAKE_SCREEN_SOURCE
	script.reload()
	var node: Control = Control.new()
	node.set_script(script)
	var scene: PackedScene = PackedScene.new()
	scene.pack(node)
	node.free()
	return scene


func test_go_to_mounts_screen_and_passes_params() -> void:
	assert_true(_router.go_to(&"world_select", {"world_id": "W02"}), "go_to succeeds")
	assert_eq(_router.current_screen_id, &"world_select", "current id")
	assert_eq(_router.current_screen.get_parent(), _host, "mounted under host")
	assert_eq(_router.current_screen.received_params, {"world_id": "W02"}, "setup params")


func test_back_pops_stack_then_requests_exit_at_root() -> void:
	_router.go_to(&"home")
	_router.go_to(&"world_select")
	_router.go_to(&"level_select", {"world_id": "W01"})
	assert_eq(_router.stack_depth(), 3, "three entries")
	assert_true(_router.back(), "back to world_select")
	assert_eq(_router.current_screen_id, &"world_select", "popped")
	_router.back()
	assert_eq(_router.current_screen_id, &"home", "at home")
	assert_false(_router.back(), "root back returns false")
	assert_eq(_exits, 1, "exit requested once")


func test_back_closes_screen_modal_before_navigating() -> void:
	_router.go_to(&"home")
	_router.go_to(&"world_select")
	_router.current_screen.modal_open = true
	assert_true(_router.back(), "consumed by modal")
	assert_eq(_router.current_screen_id, &"world_select", "still on screen")
	assert_false(_router.current_screen.modal_open, "modal closed")


func test_screen_navigate_signal_drives_router_and_home_clears_history() -> void:
	_router.go_to(&"home")
	_router.current_screen.navigate_requested.emit(&"world_select", {})
	assert_eq(_router.current_screen_id, &"world_select", "navigated via signal")
	_router.current_screen.navigate_requested.emit(&"home", {})
	assert_eq(_router.stack_depth(), 1, "home resets history")
	_router.current_screen.back_requested.emit()
	assert_eq(_exits, 1, "back from home exits")


func test_unknown_route_fails_without_changing_screen() -> void:
	_router.go_to(&"home")
	var before: Node = _router.current_screen
	assert_false(_router.go_to(&"does_not_exist"), "unknown route rejected")
	assert_eq(_router.current_screen, before, "screen unchanged")
	assert_eq(_router.stack_depth(), 1, "stack unchanged")


func test_previous_screen_is_freed() -> void:
	_router.go_to(&"home")
	var first: Node = _router.current_screen
	_router.go_to(&"world_select")
	await tree.process_frame
	assert_false(is_instance_valid(first), "old screen freed")


func test_app_state_tracks_level_phase() -> void:
	var state: Node = add_node(AppStateScript.new())
	assert_eq(state.session_id.length(), 16, "8-byte hex session id")
	state.enter_screen(&"level", {"level_id": "W01_L003", "world_id": "W01"})
	assert_eq(state.phase, AppStateScript.Phase.IN_LEVEL, "in level")
	assert_eq(state.current_level_id, &"W01_L003", "level id")
	state.enter_screen(&"level_select", {"world_id": "W01"})
	assert_eq(state.phase, AppStateScript.Phase.MENU, "menu")
	assert_eq(state.current_level_id, &"", "level cleared")
	assert_eq(state.current_world_id, &"W01", "world kept")
