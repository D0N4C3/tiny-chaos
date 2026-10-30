# Agent start/resume cheat sheet (low-context workflow)

**Do not restart from page one of the design docs on every new session.**

### Start / resume

1. Read root `AGENTS.md` (Claude loads through `CLAUDE.md`).
2. Read `docs/progress/CURRENT_STATE.md` (short handoff, not a journal).
3. Run `git status --short` and `git log -6 --oneline`.
4. From `docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv`, select **only** the rows for current task IDs (use Python filtering or `rg` for short lines).
5. Navigate to feature code; read `AGENTS.md` at its closest owning directory. Open the primary spec from root router and any relevant test—not the entire doc tree.
6. Implement one coherent feature; validate; commit with ID; update short status including actual SHA.

### At the end of a feature

Update `docs/progress/CURRENT_STATE.md` with: active milestone, completed IDs and latest SHA, tests/evidence, known blockers, files to read next, and next 1–3 task IDs. Keep it under ~80 lines. Keep detailed historical notes in `docs/progress/` separate from the hot-path current state.

### Context discipline

- Never print whole large CSVs or scan the entire repo if a path is known.
- Avoid loading all PNGs, audio, levels, and QA cases at once; inspect selected samples.
- Store decisions in `docs/decisions/` instead of repeatedly re-deriving them.
- After compaction/restart, reuse `CURRENT_STATE`, task ID and commit history; don't reimport huge specs.
- The master full-game target is not reduced by reading fewer files; all 120 levels and shipping integrations remain required.
