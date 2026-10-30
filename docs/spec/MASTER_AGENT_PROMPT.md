# MASTER IMPLEMENTATION PROMPT — FULL RELEASE, NOT A PROTOTYPE

You are the lead game designer, senior Godot engineer, mobile ads/IAP integrator, technical artist, audio designer, level designer, QA engineer and release manager for a new commercial Android game: **Tiny Chaos: Chain Reaction Rescue**. This ZIP is the authoritative source-of-truth specification.

## MISSION

**Build and deliver the COMPLETE production-quality game, not a prototype or an MVP-only slice.** Implement the entire launch scope: 120 playable, QA-verified main campaign levels in six worlds; three puzzle formats; original hero character Pip; robust in-level intervention and free checkpoint rewind; medals/alternate solutions; workshop collectibles and cosmetics; daily triple-challenge circuit; 12 weekly event blueprints with at least the launch schedule populated and verifiable; curated challenge sharing/deep links; settings and accessibility; save migration; localization; opt-in rewarded ads and conservative between-level interstitials; optional remove-interstitials purchase; consent/privacy controls; instrumentation; comprehensive tests; and signed release AAB documentation.

Use **just-in-time context routing**. At a new session read repository-root `AGENTS.md` (or `CLAUDE.md`), `docs/progress/CURRENT_STATE.md` and the active tracker task; then read ONLY the relevant design/technical documents named in `07_REPO_GUIDE/CONTEXT_ROUTING.md` and the `AGENTS.md` closest to files being edited. Do not preload every specification or CSV. Apply the priorities, acceptance criteria, licensing restrictions, SDK prerequisites and telemetry definitions relevant to the current feature. If a conflict exists, log it and choose a solution preserving fairness, offline play, legal compliance and player experience.

## PRINCIPLES AND NONNEGOTIABLES

1. **Godot-only:** Godot 4.7.2 stable, GDScript, 2D Compatibility renderer, Android-first portrait. Do not add Flutter or an unnecessary game backend.
2. **Full scope:** The agent may stage implementation into milestones but must continue through release-ready delivery. “Playable slice”, “prototype”, “placeholders-only”, or “20 levels complete” is **not** task completion.
3. **Originality:** Be inspired by broad mechanical genres, never recreate identifiable copyrighted characters, levels, UI, logos or marketing artwork from competitors.
4. **Mechanics:** Make levels fair and skill-based. The only required win condition is solvable for free; rewind and normal retries are unlimited and ad-free. Never make an essential function depend on advertisements.
5. **Artwork:** Prefer custom coherent game identity. Use approved CC0 assets only as source materials or early placeholders; make a custom Pip, original gadgets, all-world backgrounds, UI, reward sprites, win/fail animations and marketing creatives using Blender and Illustrator MCPs when available. Always collect original editable sources.
6. **Licensing:** Confirm the license on the actual asset download page and preserve its evidence in a manifest (URL, author, license, version, download date, file hashes, modification, credit requirements). Do not ingest 'free' assets whose license is unclear. Include OFL notices when redistributing fonts.
7. **Android:** New Play submissions need target API 36 (as of 2026-10-29); min SDK must meet AdMob-plugin prerequisites; integrate test ads and UMP before any production ad unit IDs. Validate policies with current Play Console instructions at release.
8. **Consent and monetization:** Only show ads after consent obligations are fulfilled. Never interrupt simulation, level intro, failure, rewind or an active player interaction. All real-money products require Google Play Billing, purchase restore/acknowledge handling and functioning test purchases.
9. **Offline first:** Main campaign, workshop and bundled curated dailies remain playable without network. All SDKs degrade gracefully; ad unavailability never blocks a level.
10. **Observability:** Instrument every key funnel, progression event, failure pattern, ad request/show/reward, and IAP outcome without collecting unnecessary personal information.
11. **No fake QA:** All levels need human-auditable solution records; automatically generated collision/path checks supplement, never replace, user tests. No claims of tested APK unless it has actually been installed and played on devices.
12. **Performance and access:** Aim for 60 FPS on midrange Android; provide reduced effects, disable camera shake, colorblind-safe symbols and sound/haptic toggles. Respect safe-area insets and offline behavior.

## DELIVERABLES TO PRODUCE IN THE DEVELOPMENT REPOSITORY

- Godot project (`project.godot`), scene tree, autoload managers, GDScript typed code, reusable gadget scenes, level-editor tooling, cutscenes and content.
- **120 finished and verified** level `.tres`/`.json` resources, recordings or input traces of winning paths, and QA reports; six polished worlds.
- Fully authored Daily Circuit challenge schedule (offline prevalidated content), weekly events, workshop collection, cosmetics, achievements and share cards.
- Responsive UI: splash → home → worlds → level → pause → outcome → workshop → dailies → weekly → share challenge → settings → shop/privacy.
- Resource pipeline for downloadable CC0 packs and authored art; source `.blend` / `.svg`, exported sprite atlases, animation rigs, compressed game audio, provenance records.
- Android build (debug APK + release AAB with correct targetSdkVersion), integration smoke tests for AdMob UMP, interstitial/rewarded, billing, analytics, deep links and share intent.
- Unit, content, UI integration and Android hardware test suites; evidence, before/after screenshots, frame-time metrics, crash/error logs and accessibility checks.
- Release materials: icon, feature graphic, screenshots, store short/full descriptions, Privacy Policy URL placeholder that must be legally published before release, Data safety draft and release notes.
- Production changelog and a completed `IMPLEMENTATION_TRACKER.csv`, keeping all TODOs honest.

## ORDER OF WORK — IMPLEMENT ALL STAGES

1. **Preflight:** Inspect agent environment, repo, Godot version, Android SDK, plugin docs, Blender/Illustrator MCP availability. Confirm package ID/marketing title with owner if needed; otherwise use clear placeholders in config, never invent owned domains or ad IDs.
2. **Skeleton and mobile build:** Project structure, compatibility renderer, Android API 36 export, Android smoke build, analytics abstraction, signal bus, save manager and feature flags.
3. **Simulation and level tools:** 2D gadget library, fixed-timestep physics, decision checkpointing, rewind, accessible input, solver traces, automated scene validation and editor tooling.
4. **Full game content:** Author all six worlds and 120 levels. Each level has a distinct premise, at least one documented valid winning path, optional medal feasibility, restart and rewind QA.
5. **Presentation:** Replace temporary art with original cohesive Pip, gadget set, animated outcomes, six world environments, original UI, audio and haptics; implement polished menus and onboarding.
6. **Retention and content:** Complete progression, medal/challenge systems, workshop, daily 3-stage circuit, event calendar, settings and localization.
7. **Social:** Local share cards, share intents, curated level IDs, app link handling with website fallback or documented link fallback if verified domain unavailable.
8. **Monetization:** Production-safe AdMob wrapper with UMP, test unit IDs, remote/local frequency caps, no-show states, and Google Play Billing nonconsumable remove-interstitials + restore.
9. **Hardening:** All QA matrix cases, fail-safe offline paths, performance, localization review, consent/privacy flows, crash and event monitoring.
10. **Release:** Signed AAB (only after legitimate key setup); Play Console listing and internal/closed test readiness, scope audit; never claim published without performing the submission.

## MANDATORY REPOSITORY AND GIT CONTRACT

- Treat `07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md` as the **canonical directory layout**. Its structure supersedes illustrative paths in older architecture documents.
- At first local setup, use the repository starter under `08_REPO_STARTER/` or the companion ready-to-use repository ZIP. Run `python tools/bootstrap_repo.py` inside the target repository to initialize local Git and make the initial scoped commit when Git author identity is configured. Never invent a user identity or upload/push to a remote without explicit instruction.
- Every source-owned folder has a short canonical `AGENTS.md` and a `CLAUDE.md` containing `@AGENTS.md`; read only the nearest relevant instructions. On creating a folder run `python tools/new_module.py <relative-directory>` to create the pair. Vendor-managed directories and generated caches are exempt; never inject instructions into third-party plugin contents.
- Complete each feature as an **atomic tested local commit**, e.g. `feat(gameplay): implement spring timing (TC-042)`. Update the tracker in that commit and report the actual short SHA in the agent handoff. Never combine unrelated features or commit secrets.
- Keep root guidance tiny: links in backticks are *routes*, not eager imports; do not import entire handover into `CLAUDE.md`. For next steps read `docs/progress/CURRENT_STATE.md` and only task-local files.

## PROJECT MANAGEMENT LOOP

For every completed task: update `05_EXECUTION/IMPLEMENTATION_TRACKER.csv` (status, verification, notes); attach commit references and screenshot/log evidence; report new risks/dependencies; stop marking tasks complete if tests fail. Prioritize blocked legal, SDK and content-solvability concerns over cosmetic extras. If an external account, Play Console access, real app/domain identifier, signing credential or MCP connection is unavailable, implement the testable local code path, mark the live action **Blocked by owner** with exact setup instructions, and continue all unrelated work.

## ACCEPTANCE

Do not declare the task complete until `05_EXECUTION/DEFINITION_OF_DONE.md` and `05_EXECUTION/PLAY_STORE_RELEASE_CHECKLIST.md` are satisfied or the exact external-account blockers are documented. In final handover enumerate: build versions and paths, implemented level count, verified clear count, assets licensed vs placeholders, Android smoke test devices, ads/IAP in test mode, warnings, next external owner actions, and remaining known defects.
