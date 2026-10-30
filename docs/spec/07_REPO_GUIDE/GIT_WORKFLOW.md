# Local Git workflow: initial commit + one tested feature per commit

## One-time developer-machine bootstrap

1. Extract the repo-ready ZIP (or create the project with `08_REPO_STARTER/create_repo_from_handover.py`).
2. From the **Godot project root**, run `python tools/validate_agent_guidance.py`.
3. Run `python tools/bootstrap_repo.py`. This initializes **local** Git on `main`, checks `.gitignore` and staged files, then creates the first scaffold commit **only if** a Git name/email are already configured. Otherwise it prints the next steps and stops; it never invents an identity.
4. Run `git log -1 --oneline` and `git status --short` to confirm a clean baseline. Do not create a remote/push unless the owner separately authorizes it.

### Manual equivalents

```bash
git init -b main
git status --short
git add -- AGENTS.md CLAUDE.md README.md project.godot .gitignore .gitattributes .editorconfig addons core features ui content assets art_source docs tests tools
git diff --cached --check
git diff --cached --stat
git commit -m "chore: bootstrap Tiny Chaos Godot repository"
```

If Git reports a missing identity, have the real contributor configure `user.name` and `user.email` themselves (local repo settings can be used). Don't write arbitrary owner information. Never stage signing keys, `.env`, private credentials or generated build outputs; review `git diff --cached --name-only` before committing.

## Required per-feature cycle

```bash
git status --short                         # inspect pre-existing changes
# Read the specific tracker row and nearest AGENTS.md, implement one scope
python tools/validate_agent_guidance.py   # verify folder instructions
git diff --check
# Run relevant Godot/tests and record exact commands + results.
git add -- path/to/changed/feature path/to/test docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv
git diff --cached --check
git diff --cached --stat
git commit -m "feat(gameplay): add rewind checkpoint restore (TC-042)"
git log -1 --format='%h %s'
```

- Commit after each **completed, tested feature**, not after a large milestone. Example scopes: one spring gadget, checkpoint restore, workshop display, tested ad wrapper, one level batch, new asset import with ledger.
- Use Conventional Commits: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf` with one module/scope and tracker ID. Do not combine unrelated changes.
- Update tracker status, QA evidence and the task ID in the feature commit. Capture the resulting SHA in the **handoff message** after the commit. A commit cannot include its own hash in its content (doing so would change its hash); if a durable SHA map is needed, record it in a separate subsequent docs-only commit.
- On failing checks: do not call the feature complete; fix or create a documented blocker. A WIP checkpoint commit is allowed if labeled `wip:` and tracker remains In Progress. Never invent successful test output.
- Never amend/force push, delete branches, reset hard, or rewrite others' commits without explicit instruction. Don't auto-push or create public repos; local Git is the default.
- For generated `.blend`/audio files, verify Git LFS availability before tracking via LFS. If unavailable, avoid committing enormous binaries and document the alternative; do not silently lose originals.

## Resume protocol for AI agents

Read `docs/progress/CURRENT_STATE.md` and `git status --short`. If the working tree is dirty, determine if those edits are the user's work before changing them. Inspect last relevant commits: `git log -8 --oneline`. Select one tracker row and its doc route; don't reread the entire package. After each feature, update the concise progress file with task ID, what passed, actual commit SHA and next task.

Reference: https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html
