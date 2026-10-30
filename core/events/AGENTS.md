# App-wide event bus and typed event contracts

Scope: `core/events/`. Owns the `EventBus` autoload: cross-feature signals only (results, economy, settings, consent, entitlements, navigation). Per-level runtime signals stay on `LevelRuntime`. Emit through the typed `emit_*` helpers; never put logic, state or SDK calls here. Add a test in `tests/unit/test_event_bus.gd` for each new event.

Follow root `AGENTS.md` for commits/tests. Read only task-relevant specs.
