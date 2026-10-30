# Player-facing monetization orchestration

Scope: `features/monetization/`. Never call SDKs inside physics nodes. Consent, cadence and reward truth go through `core/services/`; never show ads on failure/rewind.

Follow root `AGENTS.md` for feature commits, QA evidence, context routing and secrets. This file is local only; avoid duplicating full design specs.
