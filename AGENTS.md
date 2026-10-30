# Tiny Chaos — repository instructions (canonical; keep short)

**Product:** Full Android game, Godot 4.7.2/GDScript, no Flutter. `project.godot` and Git root are this directory. Requirements are in `docs/spec/`; scope is release-ready game, not a prototype.

## First 3 steps in every session

1. Read `docs/progress/CURRENT_STATE.md` (short state) and check `git status --short` and `git log -5 --oneline`.
2. Select the current task ID from **filtered rows** of `docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv`. Read the nearest folder `AGENTS.md` before modifying its files.
3. Open only the **primary** spec linked by the route below; additional docs only when essential. **Do not open all specs/CSVs** or eagerly import them into CLAUDE.md.

## Task routing (files are paths, not auto-imports)

| Working on | Start at | Read only relevant spec |
|---|---|---|
| Godot build/setup/Git | root, `tools/` | `docs/spec/07_REPO_GUIDE/GIT_WORKFLOW.md` |
| Physics, gadgets, rewind | `features/gameplay/` | `docs/spec/02_TECH/02_PHYSICS_REWIND_LEVEL_PIPELINE.md` |
| Worlds/levels | `features/campaign/`, `content/levels/` | `docs/spec/01_PRODUCT/05_WORLD_AND_CONTENT_BIBLE.md` + level-specific CSV row |
| Saves/platform services | `core/` | `docs/spec/02_TECH/04_SAVE_CONFIG_AND_PRIVACY.md` |
| Ads, purchases, consent | `features/monetization/`, `core/services/` | `docs/spec/02_TECH/03_ANDROID_ADS_BILLING_ANALYTICS.md` |
| Workshop/retention | `features/workshop/`, `features/progression/` | `docs/spec/01_PRODUCT/02_RETENTION_PROGRESSION_ECONOMY.md` |
| Dailies/weekly/social | `features/dailies/`, `features/weeklies/`, `features/social/` | `docs/spec/01_PRODUCT/06_DAILY_WEEKLY_SOCIAL_SYSTEMS.md` |
| UI/accessibility | `ui/`, `features/settings/` | `docs/spec/01_PRODUCT/03_UX_UI_ACCESSIBILITY.md` |
| Original/free art and audio | `assets/`, `art_source/` | `docs/spec/03_ART/01_VISUAL_IDENTITY_AND_ART_BIBLE.md` |
| Testing and release | `tests/`, `tools/` | `docs/spec/05_EXECUTION/DEFINITION_OF_DONE.md` |

Full map: `docs/spec/07_REPO_GUIDE/CONTEXT_ROUTING.md`. Module rules: nearest `AGENTS.md`. Canonical tree: `docs/spec/07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md`.

## Nonnegotiable work and Git rules

- Maintain **one module per responsibility**; feature scenes/scripts/local art together, shared infrastructure under `core/`, validated level data under `content/`. Use typed GDScript, snake_case filenames, explicit signals/APIs, small reusable scenes. Do not create unnecessary singletons.
- **Initialize local Git before feature work:** run `python tools/bootstrap_repo.py` once. Do not create/push a remote or fabricate Git author identity.
- **Commit every completed feature separately**, with its tests, tracker row and evidence: `feat(module): description (TC-123)`. Review `git diff --cached --stat`, run relevant tests, then commit. Do not touch unrelated user changes or commit secrets. Save actual short SHA in feature handoff.
- Every **new project-owned folder** needs a short `AGENTS.md` and `CLAUDE.md` (`@AGENTS.md` only). Generate via `python tools/new_module.py <path>`; do not alter vendor plugin folders.
- Always run `python tools/validate_agent_guidance.py` and relevant tests before feature commits. Do not claim unrun tests or unfinished content passed.
- Full target: 120 verified levels, daily/weekly, art, accessibility, test ads/IAP, offline behavior, Android release readiness. No ad on failure or rewind; no pay-to-win; maintain source/license ledger and never commit signing secrets.
- At pause/end update `docs/progress/CURRENT_STATE.md` concisely; next session should not need to reread the master prompt.

## Godot AI MCP — Development Rules

- Prefer Godot AI MCP for editor operations,
  scene inspection, script validation, and runtime tests.
- Use ordinary filesystem tools for bulk code changes
  when more efficient.
- Use MCP tools only when relevant to the current task.
- Do not enumerate or load every available MCP tool.
- Read only the relevant folder AGENTS.md and
  task-specific specification files.
- Validate modified GDScript and scenes using Godot.
- Run the affected gameplay before marking a feature done.
- Inspect runtime errors after testing.
- Never claim a feature works without verification.
- Update the implementation tracker after each feature.
- Commit each completed and validated feature separately.
- Preserve the existing project architecture.
