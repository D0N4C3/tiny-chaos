# App navigation (as built, P01-002)

Autoload order: `EventBus` → `AppState` → `SceneRouter` (plus dev-only `_mcp_game_helper`, see R16).

- `core/app/boot.tscn` (main scene) prints build info, then `SceneRouter.go_to(&"home", {}, false, true)` once the Home route exists.
- `core/app/screen_routes.gd` is the single route table (screen id → scene path). Adding a screen = add a row; core never imports feature classes.
- `SceneRouter` mounts one full screen at the tree root (`current_scene`), keeps a back stack of `{id, params}`, calls `setup(params)` before entering the tree, and connects the screen's `navigate_requested(screen_id, params)` / `back_requested()` signals (contract: `docs/architecture/ui_screen_contract.md`).
- Back (Android `NOTIFICATION_WM_GO_BACK_REQUEST`, desktop `ui_cancel`): `screen.handle_back()` (close modal / pause level) → pop stack → at root emit `exit_requested` and quit. `application/config/quit_on_go_back=false` so Godot doesn't quit before the router decides.
- Navigating to `home` clears history. Missing routes push an error, emit `EventBus.runtime_error_reported(&"route_missing", id)` and leave the current screen in place.
- `AppState` holds session-only state: random per-launch `session_id`, `phase` (BOOTING/MENU/IN_LEVEL), current screen/world/level, `is_backgrounded`.
