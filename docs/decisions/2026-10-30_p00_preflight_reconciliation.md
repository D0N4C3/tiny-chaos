# P00 preflight: toolchain pin and spec/starter reconciliation

**Affected tasks:** P00-001, P00-002, P00-003, P00-008, P00-010

## Context

The handover spec (`docs/spec/`, v2 2026-10-30) passes its own data audit (`python -I docs/spec/06_TEMPLATES/VALIDATE_HANDOVER_DATA.py`: 120 levels, 90 dailies, 12 weekly events, 36 weekly missions, 12 gadgets, 48 cosmetics, 177 tasks, 129 QA cases, 51 events). The conflicts found were between the spec and the repo starter/developer machine, not inside the spec.

## Decisions

| # | Conflict | Decision |
|---|---|---|
| 1 | Starter `project.godot` used Mobile renderer, 1152×648 landscape | Compatibility renderer (desktop + mobile), 1080×1920 portrait, handheld orientation portrait, 540×960 desktop window override (spec 02_TECH/01, 01_PRODUCT/03) |
| 2 | Physics tick unspecified in project | Pinned `physics_ticks_per_second=60` explicitly (spec 02_TECH/01) |
| 3 | Typed GDScript was a convention only | `untyped_declaration` warning enabled project-wide |
| 4 | Brand: "Tiny Chaos: Chain Reaction Rescue" is a working title pending trademark search | Launcher/app name "Tiny Chaos"; full title only in store drafts until owner clears it (OWNER_INPUTS) |
| 5 | Package ID not owner-supplied | Placeholder `com.yourstudio.tinychaos` in export preset; never presented as the owner's ID |
| 6 | Machine had only 4.7.1 **mono** templates; editor is 4.7.2 standard | Install official 4.7.2 standard templates (SHA-512 verified against the release `SHA512-SUMS.txt`); never mix template/editor builds |
| 7 | JDK 21 on PATH; spec says JDK 17 compatibility | Godot editor `java_sdk_path` stays on JDK 17 for Gradle builds; `tools/check_toolchain.py` only requires ≥17 on PATH |
| 8 | `addons/godot_ai` (dev MCP bridge) registers autoload `_mcp_game_helper` | Allowed for development/debug builds only. Before any release export (P11) it must be removed from release presets or disabled; tracked as a release blocker |
| 9 | `3d/physics_engine="Jolt Physics"` from editor default | Left as-is; 3D physics is unused (2D game) |

## Alternatives rejected

Mobile (Vulkan) renderer: higher device floor and no benefit for 2D faux-3D sprites. Using 4.7.1 mono templates: version mismatch breaks exports and adds unneeded .NET.

## Consequences / verification

`python tools/check_toolchain.py --godot <Godot_v4.7.2 console exe>` is the repeatable environment check. Desktop boot verified via Godot AI MCP run (log: `[boot] ready ... engine=4.7.2-stable (official) renderer=gl_compatibility`). Android export evidence is recorded in the tracker row P00-010.
