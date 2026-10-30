# Fair physics, free rewind and level authoring pipeline

## Core risk: physics reproducibility

Physics engines are not automatically bitwise deterministic across platforms or hardware. Do not promise an arbitrary 'time slider' from only a random seed. The product requirement is **instant replay from deliberate checkpoints**, not universal reverse-time simulation.

## Decision checkpoint design (launch)

- Each curated level defines 0–2 authored checkpoint anchors (`checkpoint_id`, `trigger_event`, `enabled_interventions`, `snapshot_scope`).
- At a checkpoint: pause gameplay simulation in a controlled phase; snapshot each relevant `RigidBody2D`'s position, rotation, linear/angular velocity, sleeping state; all active gadget states, animation/sensor state, pending timers, action counters and RNG state. Store puzzle state in a typed structure, not a screen texture.
- Restore path: stop simulation safely; cancel scheduled timers/tweens/particle effects; reconstruct/resynchronize necessary bodies (including joints), apply velocities via physics-safe hooks, reset trigger eligibility and processed-event ID sets, resume after collision world settling.
- If precise state restore proves unstable, replace that checkpoint with a **deterministically reauthored phase boundary** and reload the known starting state for that phase. This is acceptable and safer than a broken visual rewind.
- Rewind button must restore state **without consuming screws, medals, ads or attempts**. Optional action history screen may show the previous two decisions.

## Physics fairness and gameplay control

- Use fixed timestep; zero/limited randomness in core route outcomes. Sound and particles may randomize without affecting hitboxes.
- Every `Save It` input event has visual pre-cue ≥0.4s on early levels; typical timing window starts at ~600–1000ms and narrows only when tested. Optional assistive mode slows action but preserves achievements.
- 'Rope/lever' states defined by finite state machines. Snap slots have 2–4 valid placements with clear ghost preview. Avoid single-pixel solution positions.
- Strict energy caps, max velocity, portal cooldown and out-of-bounds cleanup so objects never tunnel uncontrollably or get permanently stuck.
- On failure, log a reproducible cause code with last action, relevant body state and timing; do not simply display 'Nope'.

## Required tools

1. **Level editor**: drag fixtures/gadgets and define slot constraints/checkpoint anchors, score/medal conditions, intro framing and comedy endpoint.
2. **Validator**: schema checks, unique IDs, supported gadget types, reasonable coordinates and bounds, one goal, at least one supported solution path, verified asset references, all medals feasible in authored test playback, no cycle traps; emits machine-readable report.
3. **Solution recorder**: records player's placement/taps (relative to physics tick) and state hashes/events. Playback should complete repeatedly on tested hardware; if cross-device variance occurs, expand valid interaction windows or use deterministic scripted triggers.
4. **Content report**: level IDs, full winning traces, best times, failure exits, QA status, median solve time from playtests, localization readiness.
5. **Randomized fuzz runner**: identifies unwinnable stuck physics, infinite loops, off-screen bodies and crashes; complements deliberate authored solutions.

## Proposed level document schema

See `04_CONTENT/level_schema.json` for a JSON Schema and `04_CONTENT/example_levels/` for **illustrative untested authoring examples**. World and level identity canonical format: `W01_L001` ... `W06_L020`; global level 1–120 can be derived. Each completed level has:

- id, world, index, localized title/brief IDs, puzzle type, mechanics introduced, difficulty tier.
- geometry: static collider, dynamic bodies, gadget placements, launch spawn, goal and out-of-bounds.
- player choices: draggable gadget palette, snap sockets, runtime interactable controls, max simultaneous actions.
- authored checkpoint triggers and serialized phase state.
- primary win condition, fail causes, optional medal conditions, input trace of at least one guaranteed win.
- QA counters: replay success on target devices, performance, humor payoff and human-clear review.

### Example solution trace shape

```json
{
  "level_id": "W01_L003",
  "engine_version": "4.7.2",
  "actions": [
    {"at_tick": 0, "type": "place", "socket": "spring_a", "gadget": "spring", "rotation_deg": -15},
    {"at_tick": 1, "type": "start"},
    {"at_tick": 93, "type": "tap", "control": "flipper_b"}
  ],
  "expected_result": "primary_goal",
  "qa_status": "DESIGN_ONLY_NOT_VERIFIED"
}
```

The agent must replace design-only traces with real recorded, repeatedly verified traces before declaring gameplay finished.

## Daily and weekly authored content pipeline

The supplied `DAILY_CHALLENGE_PLAN_90.csv` and `WEEKLY_EVENT_PLAN_12.csv` are briefs. Turn every scheduled challenge into a **content asset that has passed the exact same validator/clear verification as the campaign**. Rotation schedule references only `qa_status == RELEASE_APPROVED` assets; unknown or failed entries use a fallback approved daily challenge instead of exposing broken content.

## Editor/testing automation

- Batch import every level, run schema validation, simulate tested input traces repeatedly, produce `build/reports/level_solves.csv` with success rate, retries and frame time.
- Test win/fail determinism across Android 9+, API 36 targets, various SoCs / screen sizes; document actual hardware available.
- Smoke-test each gadget at slow/fast timescale, in pause/resume and after orientation/app background transitions.
- Exports cannot claim physically verified levels merely because the JSON parses.
