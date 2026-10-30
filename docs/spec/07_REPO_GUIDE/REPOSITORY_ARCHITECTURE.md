# Canonical Godot repository structure (v2)

**Source of truth for where new code and assets belong.** Use this instead of older illustrative scene-tree examples. Godot project root == Git root (`project.godot` at root). Godot recommends organizing scenes near their related assets and snake_case for file and directory names.

## Lean, feature-first tree

```text
tiny-chaos-godot-repository/
  AGENTS.md                  # 1-page policies + task router, read at session start
  CLAUDE.md                  # exactly @AGENTS.md, not duplicated content
  README.md                  # setup, non-agent overview
  .gitignore .gitattributes .editorconfig project.godot
  addons/                    # vetted version-pinned Godot plugins; do not edit vendors
  core/                      # cross-feature platform and contracts only
    app/                     # boot, navigation/state transitions
    services/                # ads/analytics/billing adapters, portable mock interfaces
    save/                    # versioned save files and migrations
  features/                  # scene + script + local assets per feature
    gameplay/
      gadgets/               # typed gadget scenes / contracts
      checkpoints/           # fixed decision checkpoint + restore
    campaign/                # world/level unlock flow
    progression/             # medals and rewards
    workshop/                # cosmetics and invention collection
    dailies/                 # daily circuit and scheduling
    weeklies/                # weeklies and event content
    social/                  # challenge IDs, shares and safe fallbacks
    monetization/            # orchestration of services, UI triggers
    settings/                # accessibility/controls/consent preference UI
  ui/
    screens/                 # menus not owned by one feature
    widgets/                 # tiny reusable widgets, themes, safe area tools
  content/                   # shipping, validated, data-driven content
    levels/world_01/ .. world_06/
    events/                  # daily/weekly authored bundles
    localization/            # source strings, locale assets
  assets/                    # optimized import-ready assets, not original .blend projects
    art/ audio/ fonts/
  art_source/                # original editable .blend/.svg, reference and provenance
    blender/ illustrator/
  tests/                     # independent tests and verification evidence
    unit/ content/ device/
  tools/                     # validators, lints, scripts, dev tooling
  docs/                      # documentation excluded from Godot asset import
    architecture/            # actual decisions/interfaces as built
    progress/                # CURRENT_STATE and developer handoffs
    decisions/               # architecture decision records
    spec/                    # the 01_PRODUCT .. 07_REPO_GUIDE handover source
```

Each project-owned folder (including world folders and `docs/spec/` subfolders) has its own **small** `AGENTS.md` (canonical) and `CLAUDE.md` (contains `@AGENTS.md`). Third-party plugin directories inside `addons/`, generated caches (`.godot/`, `build/`), and imported vendor asset-pack internals are exempt; do not modify vendor packages. Every newly created owned folder must be initialized with `python tools/new_module.py path/to/folder`.

## Architectural rules

1. **Prefer cohesion over layers.** Put a scene, its controller, and feature-specific animation/sprite together, not in global `scenes/` and `scripts/` catchalls. Put *shared* UI/widgets in `ui/`; put *shared* engine-agnostic services/contracts in `core/`.
2. **Direction of dependencies:** `features → core` and `ui → feature public APIs/core`; never `core → features`. A feature may talk to another feature through a small explicit public contract (signal/event or thin controller), not by reaching deep into its nodes. Tests reference modules, never the reverse.
3. **Keep autoloads few.** Only app-level router, save service, event bus, and thin platform adapters when justified. Do not create one singleton per minor feature.
4. **Data-driven content.** Level IDs, gadget parameters, and daily/weekly schedules are validated data; do not hardcode 120 levels as separate scene scripts. Keep reusable gadget scenes and a generic level runtime. Store human-verified winning traces separately.
5. **Scene ownership.** A scene owns its internal node paths; external modules interact via typed APIs and signals. Never rely on fragile `../../../` paths across features.
6. **Runtime loading:** `.gdignore` only in `docs/` and `art_source/` (to exclude non-loadable originals/docs). Do **not** `.gdignore` shipping `content/`, `tests/`, `tools/` or code referenced by Godot.
7. **Naming:** file/path `snake_case`; GDScript class `PascalCase`; constants `SCREAMING_SNAKE_CASE`; nodes `PascalCase`; stable level IDs W01_L001; signal names past-tense verbs for results (`level_completed`).
8. **Plugins:** pin exact source/version/checksum; keep third-party addons isolated. Use adapter wrappers in `core/services/`; avoid changing vendor code directly.
9. **Asset rights:** originals in `art_source/`, exports in `assets/`; record licensing/provenance in `docs/spec/03_ART/LICENSE_LEDGER.csv`. Use Git LFS selectively for large source assets only after verifying LFS is installed.
10. **No speculative folders:** create a new folder only when it has an owner, responsibility, files, and guidance; this initial skeleton is the full intended launch-domain map, not permission for unlimited nesting.

## Rules for placing new files

| New work | Location |
|---|---|
| A new playable gadget | `features/gameplay/gadgets/` |
| Rewind and snapshot logic | `features/gameplay/checkpoints/` |
| Level definition for world 3 | `content/levels/world_03/` |
| Level authoring/verification command | `tools/` and `tests/content/` |
| Interstitial SDK wrapper | `core/services/` |
| Placement of ads after win | `features/monetization/` |
| Shared confirmation modal | `ui/widgets/` |
| Pip source mesh/vector | `art_source/blender/` or `art_source/illustrator/` |
| Pip exported sprite atlas | `assets/art/` |
| Weekly mission bundle | `content/events/` |
| Architecture decision | `docs/decisions/` |
| Current progress/next task | `docs/progress/CURRENT_STATE.md` |

## Official reference

- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html
