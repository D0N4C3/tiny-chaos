# FULL PRODUCTION SEQUENCE — THERE IS NO 'STOP AT PROTOTYPE' PHASE

The purpose of this package is to direct the agent through a *complete commercial game*. Milestones are dependencies and handoff gates, not permission to end after the core gameplay is playable. The exact action list and evidence columns are in `IMPLEMENTATION_TRACKER.csv`.

## Phase gates and shipping artifacts

| Milestone | Deliverable | Exit criteria |
|---|---|---|
| P00 Preflight | Pinned engine, repo, Android build/asset and tool audit | Android debug export works, external-account blocker list written |
| P01 Foundation | Responsive UI, navigation, saves and setting shells | Android scene navigation and persistence tests pass |
| P02 Physics/toolchain | All 12 gadgets, intervention, checkpoint fallback, level editor/solver | Functional on Android, physics repeatability test pass |
| P03 Campaign | 6 worlds and **120 validated main levels** | Every ID playable, human+recorded win, medals reviewed, no blockers |
| P04 Art/audio | Fully original Pip, coherent machine sprites, six world scenes, UI and effects | No ship-critical placeholder art; source/licensing/Android QA complete |
| P05 Workshop | 24 inventions, cosmetics, economy and medal system | Idempotent save/reward test cases pass |
| P06 Live content | **90 daily variants and 36 weekly event stages** | Each schedule item tested on Android and only approved IDs used |
| P07 Social | Curated challenge code, share card, share intents and deep link readiness | Cross-device challenge round trip or owner domain blocker documented |
| P08 Ads/IAP | UMP, conservative ads, test rewarded, Play billing | Test track QA, privacy choices, no ad on failure, purchase restore |
| P09 Analytics/lang | 51 declared events and five release language UIs | Test event payloads, Spanish/PTBR/French/Italian human QA or owner-scoped exception |
| P10 Hardening | 129 QA cases, device tests, accessibility, legal and performance | Zero unresolved ship blockers; evidence stored |
| P11 Commercial release | AAB/Play listing/test track/rollout playbook | Release checklist signed; owner steps explicit; publish only with access/authorization |

## Workstream dependencies

- Build Android and choose stable plugin versions before elaborate art and 120 levels; stop critical platform incompatibilities early.
- The level validator/editor must exist before authoring the bulk content. The content itself can be staged **inside full production**, but final deliverable must include all 120 QA-cleared levels.
- Visual art must be developed in parallel but final import QA must use actual Android build. Blender render to Godot 2D pipeline should be proven before creating all six worlds.
- Economy, dailies, events, and sharing depend on stable level IDs and save migration.
- AdMob and billing should be integrated on a test device while completing core content, not added the day before publishing.
- No user-created levels, public chat or uncontrolled leaderboards at v1 launch.

## Checkpoint handoffs required from agent

After P00/P02/P03/P04/P06/P08/P10/P11, produce:
- Source commit and module inventory.
- Actual native build and screenshots/video evidence (where applicable).
- Level completion/validation counts with filenames; avoid vague "mostly done".
- Crash/performance and failing tests (include blockers rather than hiding them).
- Asset license ledger updates and remaining original art needs.
- Owner-specific tasks needed to proceed (AdMob IDs, owned signing key, domain, Play Console product).

## Quality process

- QA is a continuous gate, not just the final milestone.
- Automated validators fail on missing `level_id`, unsupported gadget, invalid checkpoint, absent sprites, medal impossibility (when mechanically detectable), missing translations and ad/currency event mismatch.
- Manual human clearance still required for every primary goal.
- A 'successful import' is not a 'winning level'. A functioning editor preview is not a Play-ready Android release.

## Definition of shipping success

There is a complete Godot project and signed release candidate with 120 playable/validated campaign levels, coherent original artwork, ethical ad monetization + IAP, offline daily/weekly challenges, curated sharing, settings/localization, QA evidence and published-ready legal/privacy/store materials. External account actions are explicitly reported if unavailable.
