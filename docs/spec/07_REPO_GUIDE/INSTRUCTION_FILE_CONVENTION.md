# AGENTS.md + CLAUDE.md per-folder convention

## Why two filenames

`AGENTS.md` is the canonical rule set for the folder, used by Codex and other agents. Claude uses a tiny `CLAUDE.md` with a single `@AGENTS.md` line, which imports that canonical file. This avoids divergent copies and works on Windows without symlinks.

## Required pattern in every project-owned folder

```text
features/gameplay/gadgets/
    AGENTS.md        # ~8-25 lines, specific to gadget responsibilities
    CLAUDE.md        # one line: @AGENTS.md
    spring.tscn
    spring.gd
```

When adding folders, run `python tools/new_module.py features/gameplay/gadgets/springs` or add the pair manually. This is mandatory for **project-owned** folders; exempt `.git/`, `.godot/`, generated build/cache directories and unmodified vendor-managed directories in `addons/` or imported assets. Keep instructions outside vendor packages.

## Put in AGENTS.md

- What the folder owns and **does not own**.
- Cross-module APIs to respect and important constraints.
- The **single relevant** spec path or document route, not a copied 100-line design brief.
- One precise test command **only if a real test exists**, or a reminder to run the closest tests.
- No universal rules already in root and no boilerplate that fills every agent context.

## Never put in CLAUDE.md

- Another copy of `AGENTS.md`.
- A complete master prompt, CSV, or entire design doc imported with `@`.
- Global machine instructions, secrets or personal developer preferences.

## Verify

`python tools/validate_agent_guidance.py` checks all owned directories, `@AGENTS.md` imports, size limits, required root routes and safe ignore configuration. `python tools/new_module.py ...` scaffolds new folders consistently.

Sources: https://code.claude.com/docs/en/memory ; https://learn.chatgpt.com/docs/agent-configuration/agents-md
