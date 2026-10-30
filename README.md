# Tiny Chaos: Chain Reaction Rescue — Godot repository starter

This is a **repository skeleton and complete production specification**, not a playable or completed game. Build the entire production game from `docs/spec/`; start from root `AGENTS.md` or `CLAUDE.md`.

1. Extract this ZIP to your preferred local directory. Do not copy hidden `.git` from another repository.
2. Open a terminal **inside this directory**; run `python tools/validate_agent_guidance.py`.
3. Run `python tools/bootstrap_repo.py` to initialize local Git and make the first commit. Configure your own Git name and email if prompted; no remote is created.
4. Start Claude Code or Codex **from this root directory**. Instruct it to read root instructions, inspect `docs/progress/CURRENT_STATE.md`, and continue the full-game tracker with one tested feature commit at a time.
5. When creating new folders: `python tools/new_module.py features/example_name`. In vendor-managed imported directories, do not inject rules.

**Important:** Specs are copied under `docs/spec/`, including the asset research and full implementation tracker. Root guidance uses task routing to avoid loading irrelevant large documents on every session.

For code organization see `docs/spec/07_REPO_GUIDE/REPOSITORY_ARCHITECTURE.md`; for Git see `docs/spec/07_REPO_GUIDE/GIT_WORKFLOW.md`.
