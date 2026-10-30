# Godot production architecture (Android-first)

## Runtime foundation

- **Godot 4.7.2 stable** (do not silently upgrade to 4.8 beta), typed GDScript, Compatibility renderer, 2D physics. Default portrait, safe area-aware UI. Target Android API 36+ (as of 2026-10-29); minSdk 24+ for the chosen AdMob plugin subject to verification.
- Prefer standard Godot resources (`.tres` / `.res`) for authored world/gadget properties, JSON for external validator and bundled schedule data; no arbitrary executable scripts from downloaded content.
- Set fixed physics ticks (start 60Hz) and a maximum body count; measurable 60 FPS midrange goal with 30 FPS graceful low-end fallback. Do not equate identical random seeds with guaranteed cross-platform deterministic RigidBody2D simulations.
- All scenes must work offline. Ad/analytics/IAP wrappers are adapters that never block gameplay.

## Canonical source tree (revised 2026-10-30)

For the **maintained source tree**, use `07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md` and the generated `08_REPO_STARTER` scaffold. The layout is feature-first: `features/gameplay/`, `features/campaign/`, `features/workshop/`, etc.; `core/` holds only cross-feature services; `content/` holds validated data; `ui/` holds reusable presentation; `assets/` contains engine-ready exports; `art_source/` contains editable originals; `docs/spec/` contains this full specification. The former `autoload/`, `scenes/`, `scripts/` layout was illustrative and is **not** the canonical implementation path.

**Important:** `res://` is the Git root and includes `project.godot`. Do not nest Godot under an extra `game/` directory. Keep scripts next to their owning scenes when that improves local cohesion. Godot path and autoload names must be registered after the corresponding files exist.

## Responsibility boundaries

| System | Owns | Does not own |
|---|---|---|
| `LevelRuntime` | Spawn and state of the current level; Win/Fail state | Persistent economy or ad calls |
| `PuzzleStateMachine` | `PREVIEW, PLANNING, RUNNING, CHECKPOINT_PAUSED, SUCCESS, FAILURE, RESULT` | Asset downloads |
| `GadgetController` | Gadget logic, interactions, visual cues | Arbitrary telemetry details |
| `PhysicsCheckpoint` | Snapshot/restore decision checkpoint state | Permanent save data |
| `SaveManager` | Versioned local save and migrations; safe writes | Personal user identity |
| `EconomyManager` | First-clear grants, balances, purchases of cosmetic items | Real-money purchase verification |
| `DailyManager` | UTC deterministic schedule and cached daily claims | Unvalidated random generation |
| `AdsAdapter` | Consent, availability, rewards and interstitial policy | Win/fail physics |
| `BillingAdapter` | Billing calls, entitlements and restore | Shop UI drawing |
| `AnalyticsAdapter` | Schema-bound event enqueue and offline drop/batch policy | Level success conditions |

## Data-driven gadgets (common contract)

Every gadget is a scene implementing a typed `GadgetDefinition` with `gadget_id`, state, input mode, interaction collision, fixed visual/physics attachment points, difficulty parameters and a signal `activated(gadget_id, tick)`. Examples:
- Spring: single impulse, configurable strength and orientation.
- Fan: bounded force field activated on timer/tap.
- Magnet: bounded attract/repel with visually marked poles.
- Flipper: angle-limited actuation; broad timing window.
- Conveyor: movement along surface when enabled.
- Seesaw: target torque / pivot, snap rest pose.
- Portal: source/destination connection; re-entry cooldown and speed preservation rules.
- Gravity Zone: well-defined gravity vector inside Area2D, signal/visual cue required.

All functional parameters are serialized and validated. Gadgets cannot dynamically load arbitrary third-party code from level JSON.

## Collision and simulation

Use named collision layers for: `GROUND`, `DYNAMIC_BALL`, `DYNAMIC_PROP`, `GADGET`, `GOAL`, `SENSOR`, `DRAGGABLE`. Avoid global physics hacks and modifying Rigidbody transform every `_physics_process()`: Godot recommends `_integrate_forces()` for dynamic rigid body interventions. Sensors should use clear `Area2D` enter/exit callbacks with event gating.

Gadget collision shapes must match visible outlines; make oversized touch Area2D separate from physical collision. Cap simultaneous dynamic balls, particles and joints per level. Avoid physically simulating all decorative bolts, foam pieces, or confetti.

## Game state contracts

`LevelRuntime` must emit `level_started`, `intervention_tapped`, `checkpoint_created`, `checkpoint_restored`, `level_failed(cause)`, `level_completed(medals, metrics)`. `AppState` owns unlocks. `SaveManager` records main clear before any ads or result animations, with idempotent first-clear reward grants. Ads wrappers only observe completed result state.

## Offline/online adapters

Android native plugins are not guaranteed to exist in editor or on unsupported target; `Engine.has_singleton`/plugin availability checks and no-op mocks must handle absent integrations. Provide interfaces for `TestAdsAdapter`, `NativeAdsAdapter` and `NullAdsAdapter` with identical event semantics. CI executes editor tests without an AdMob singleton.

## Version control

- Git with `.gitignore` for `.godot/`, local export/build caches and secrets; LFS for large authored `.blend`, original audio, atlases as needed.
- Pin engine and plugins via manifest with versions/links/checksums. Record differences between editor and Android export templates.
- Secrets (signing keystore/passwords, credentials, Play service account) only through secret storage/CI; never commit.

## Official references

- Godot stable download: https://godotengine.org/download/archive/4.7.2-stable/
- Android export: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- 2D RigidBody handling: https://docs.godotengine.org/en/stable/tutorials/physics/physics_introduction.html
- Renderers: https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html
