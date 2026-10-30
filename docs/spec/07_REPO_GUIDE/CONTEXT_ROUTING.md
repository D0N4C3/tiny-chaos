# Context routing: fetch only what the current feature requires

**Session start only:** root `AGENTS.md` (or Claude's `CLAUDE.md`), `docs/progress/CURRENT_STATE.md`, `git status --short`, and filtered rows of `docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv`. If starting a brand-new implementation plan, read `docs/spec/MASTER_AGENT_PROMPT.md` once. Do not open the whole library of specs or full 120-level CSV in the initial context.

## How to load targeted context

1. Classify active task, identify owning folder (`features/`, `core/`, `content/`, `assets/`, etc.). Read closest local `AGENTS.md` if needed; root rules still apply.
2. Open **one** primary spec listed below and the relevant code/tests; open a second spec only if that feature needs it.
3. Search by file name, symbol or task ID before reading large text: `rg --files features/gameplay` / `rg -n 'checkpoint' features/gameplay docs/spec/02_TECH`.
4. For large CSVs, select matching rows (by `task_id`, `level_id`, `world`) using short filtering scripts; do not dump entire CSV into agent context.
5. Record a 5–10-line status summary in `docs/progress/CURRENT_STATE.md` when the module is complete or at a pause point. Do not duplicate the full master prompt or the complete specs there.

## Task -> read only these files

| Task category | Primary spec under `docs/spec/` | Code area |
|---|---|---|
| First-time project setup, Git, structure | `07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md`, `07_REPO_GUIDE/GIT_WORKFLOW.md` | root, `tools/` |
| Game interaction, timings, gadget feel | `02_TECH/02_PHYSICS_REWIND_LEVEL_PIPELINE.md` | `features/gameplay/` |
| Level/world building | `01_PRODUCT/05_WORLD_AND_CONTENT_BIBLE.md` + selected rows `04_CONTENT/LEVEL_DESIGN_PLAN_120.csv` | `content/levels/`, `features/campaign/` |
| Level schemas/gadgets | `04_CONTENT/level_schema.json` + selected rows `04_CONTENT/GADGET_CATALOG.csv` | `features/gameplay/gadgets/` |
| Save/entitlements | `02_TECH/04_SAVE_CONFIG_AND_PRIVACY.md` | `core/save/` |
| Ads, billing, instrumentation | `02_TECH/03_ANDROID_ADS_BILLING_ANALYTICS.md` | `core/services/`, `features/monetization/` |
| Fairness/retention | `01_PRODUCT/02_RETENTION_PROGRESSION_ECONOMY.md` | `features/progression/` |
| Workshop/inventions | `01_PRODUCT/02_RETENTION_PROGRESSION_ECONOMY.md` | `features/workshop/` |
| Daily/weekly/social content | `01_PRODUCT/06_DAILY_WEEKLY_SOCIAL_SYSTEMS.md` | `features/dailies/`, `features/weeklies/`, `features/social/` |
| Art/Pip design/MCP | `03_ART/01_VISUAL_IDENTITY_AND_ART_BIBLE.md` plus relevant MCP brief | `assets/`, `art_source/` |
| Downloading external packs | `03_ART/02_FREE_ASSET_RESEARCH.md`, `03_ART/03_LICENSE_AND_PROVENANCE_POLICY.md` | `addons/`, `assets/` |
| UI/onboarding/accessibility | `01_PRODUCT/03_UX_UI_ACCESSIBILITY.md` | `ui/`, `features/settings/` |
| Test automation & performance | `02_TECH/06_TEST_AUTOMATION_PERFORMANCE.md` | `tests/`, `tools/` |
| Android release, privacy | `02_TECH/05_ANDROID_RELEASE_COMPLIANCE.md` | `core/services/`, Android export |
| QA/releases/status | `05_EXECUTION/DEFINITION_OF_DONE.md` and *filtered* `05_EXECUTION/QA_TEST_CASES.csv` | `tests/`, `docs/progress/` |

**Large data:** `LEVEL_DESIGN_PLAN_120.csv` ~68KB, localization ~47KB, full trackers ~35KB, QA cases ~31KB. Open only relevant rows. If a doc path is missing or renamed, search for filename, update this routing table once, and don't fabricate contents.

## Notes on the two instruction systems

- `AGENTS.md` is the canonical per-folder text; Codex reads it by directory/instruction scope. From repository root, do not assume Codex will auto-load deeper files before you access code: explicitly read the relevant subfolder's `AGENTS.md` before edits.
- `CLAUDE.md` in each owned folder contains `@AGENTS.md` only. Claude Code expands that local import and loads nested folder instructions on demand. Avoid additional `@` imports from specs: **an import expands content** and consumes context.
- Changing these files may require starting a new agent session to see new instructions. Never use a global-machine `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md` as the only copy: this project must remain portable.

References: https://code.claude.com/docs/en/memory ; https://learn.chatgpt.com/docs/agent-configuration/agents-md
