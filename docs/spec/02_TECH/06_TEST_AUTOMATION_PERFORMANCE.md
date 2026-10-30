# Automated verification, devices and performance

## Test pyramid

- **Unit:** currency idempotency, save versioning, level schema validator, daily rotation and locale fallback, ad cap logic, reward callbacks, IAP state machine, input buffering and medal evaluation.
- **Scene:** every gadget inside test scene at min/max speeds; timer reset, camera edges, collision layers and checkpoint reconstruction.
- **Content:** all 120 main level resources + 90 daily briefs converted to runtime missions + 36 event missions/resources; first valid winning trace per stage; optional medals tested separately; repeat 10x on reference Android device and editor.
- **Integration:** Android build with privacy UMP, offline, ad mock/test, Play Billing test, share chooser, deep links, GameAnalytics test events.
- **Human:** uncoached onboarding, color-blind symbol comprehension, at least 5 representative devices/size buckets if available; report actual devices tested, not assumed.

## Suggested CI actions

1. Godot headless import and class load.
2. GDScript lint/style and scene-path validation.
3. JSON Schema validation of level files and catalog cross-references.
4. Unit/service tests (no native plugins needed).
5. Batch content validation, repeat playback traces, screenshot capture for representative levels.
6. Export Android debug APK and unsigned AAB (if SDK configured); published signing must be handled securely.
7. Retain outputs and test results as artifacts.

## Performance objectives (targets, not measured)

- 60 FPS on modern mid-tier Android, stable 30 FPS on low-tier in reduced effects mode.
- Freeze/unfreeze and retry: median ≤1s on target midrange devices.
- Main scene initial load: ideally ≤3s after cold start; no blocking network calls.
- Memory and bundle footprint: measure; prefer atlas sprites, compressed audio, shared effects and lightweight Godot plugins. Set owner-approved target size after actual build measurement.
- Haptics/sound do not delay physics; avoid audio clipping and repeat loops masking input cues.
- Disable offscreen particle/animation updates, pool short-lived FX, bound Rigidbody count and velocity, optimize audio length and texture compression.

## Device test matrix

- Android 9 (lowest practical target if SDK allows), 11, 13, 15/16 where available.
- 720×1600 midrange, 1080×2400 mainstream, 1440×3200 high-end, tablet/foldables as practical.
- Poor GPU, low free storage, denied consent, lost network, killed activity, background/resume, dual SIM interruptions, airplane mode.

## Reporting

- Record date, Godot/Gradle/plugin versions, device model, OS, frame-time percentiles, max memory, active bodies, highest-load scene, logs, failure reproduction and signed-off acceptance.
- Run 10 repeated winning traces per level on at least one Android device when possible; compare success across devices and investigate nondeterminism.
- Never label engine-only validation as real-device QA.
