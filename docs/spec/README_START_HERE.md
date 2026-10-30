# TINY CHAOS: CHAIN REACTION RESCUE — FULL GAME AI HANDOVER

**Package date:** 2026-10-29  
**Project status:** production specification / agent handover, **not an implemented or tested game**.  
**Target:** complete, commercially distributable Android game built in **Godot 4.7.2 + GDScript**; no Flutter.  
**Working title:** *Tiny Chaos: Chain Reaction Rescue* (working brand; clear trademark, domain and store search before release).

## Start here (for the AI coding agent)

1. For a **new project**, start with `07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md` and `07_REPO_GUIDE/CONTEXT_ROUTING.md`, then generate or extract the `08_REPO_STARTER` repository layout. Initialize **local Git** (`python tools/bootstrap_repo.py`) before implementing features.
2. Read **`MASTER_AGENT_PROMPT.md` once for mission scope**, then use task-local context loading. On subsequent sessions, start with the repository's small `AGENTS.md` / `CLAUDE.md`, `docs/progress/CURRENT_STATE.md`, and the specific tracker rows for the active task. **Do not read every document sequentially**; use the routing map to open only relevant specs.
3. Keep `05_EXECUTION/IMPLEMENTATION_TRACKER.csv` up-to-date, include the task ID in each atomic feature commit, and capture actual commit SHA in the handoff report. Do not mark tasks `Done` without verification evidence.
4. Download **only the approved assets listed in `03_ART/asset_sources.csv`** after verifying the actual pack's license and storing an audit record. Assets themselves **are not bundled** in this ZIP.
5. Use the Blender and Illustrator MCP connections for the custom visual identity; reference `03_ART/BLENDER_MCP_PRODUCTION_BRIEFS.md`, `03_ART/ILLUSTRATOR_MCP_PRODUCTION_BRIEFS.md`, and `03_ART/ART_PRODUCTION_TRACKER.csv`. MCP tools are optional accelerators: never block the project if unavailable.
6. `04_CONTENT/LEVEL_DESIGN_PLAN_120.csv` is a **complete 120-level production brief**, not 120 ready-to-run validated physics levels. Build and test every playable scene; verify at least one human-accessible winning path for each.
7. Follow `05_EXECUTION/FULL_PRODUCTION_SEQUENCE.md` all the way through **signed production AAB, Play Console readiness, and post-release observability**. Do **not** stop after a prototype.
8. Use `06_TEMPLATES/AGENT_HANDOFF_REPORT.md` after each implementation milestone.

## Contents

| Folder | Purpose |
|---|---|
| `01_PRODUCT` | Game design, player journey, progression, retention, levels, live operations, UX, social and ads |
| `02_TECH` | Godot project architecture, physics and checkpoint restore, data formats, Android SDK integrations, privacy, CI and performance |
| `03_ART` | Visual identity, verified free-asset candidate URLs and licenses, original Blender/Illustrator production specs, audio, provenance |
| `04_CONTENT` | 120 level briefs; 90 daily *design briefs*, 12 weekly episode briefs and 36 mission briefs, sample machine-readable level JSON, cosmetics, localization |
| `05_EXECUTION` | 100+ implementation tasks, acceptance and QA cases, measurements, release gate, risks, production stages |
| `06_TEMPLATES` | Handoffs, decision log, issue format, change log, agent operating instructions |
| `07_REPO_GUIDE` | Canonical modular Godot structure, Git workflow, lazy context routing, module naming, resume protocol |
| `08_REPO_STARTER` | Drop-in repository skeleton with AGENTS/CLAUDE in each owned folder, Git bootstrap and validation tooling |

## Fixed product decisions

- **One-engine solution:** Godot 4.7.2 (stable as of package date) and GDScript. Renderer: Compatibility, 2D gameplay with pre-rendered faux-3D toy artwork.
- **Android-first:** Portrait, offline-first. Version 1 release ships the full 120-level main campaign + Daily Circuit + workshop cosmetics + weekly challenges + shareable curated challenges + ads + optional `remove_ads` IAP.
- **Core loop:** SPOT → PLACE / PLAN → RUN → TAP / INTERVENE → FUNNY OUTCOME → REWIND / WIN → NEXT.
- **Design philosophy:** Competence, experimentation, curiosity and player autonomy. No pay-to-win, energy timers, ads on failure, forced streaks or punishments for taking breaks.
- **Main level duration:** 20–60 s on a successful attempt; 3–5 min target play session; 6 themed worlds × 20 levels.
- **Content QA:** No release until all 120 levels are playable, discoverable, solvable without ads, reproducible on shipping Android builds, and localized as required.
- **Third-party assets:** Source links only; the agent must download and preserve separate license evidence before commercial use.

## Critical risks / reality checks

This package is a detailed **development handover**, not a guarantee of retention or viral success. It contains planning-level level briefs and JSON examples, not production-validated interactive content, and it does not include a shipped game or preapproved Google Play account settings. Play Store requirements, SDK/plugin versions, privacy obligations, and real device performance must be verified again at submission time. Any SDK integration incompatible with the chosen engine needs a documented, tested alternate route.

## References / verification date

Source research performed 2026-10-29. Canonical links and license evidence are recorded in `03_ART/02_FREE_ASSET_RESEARCH.md` and `02_TECH/ANDROID_RELEASE_COMPLIANCE.md`.
