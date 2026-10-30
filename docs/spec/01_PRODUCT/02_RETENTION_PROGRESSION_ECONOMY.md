# Retention, progression and economy — full launch rules

## Retention loops by timescale

| Horizon | Motivation | Implemented surface | Measurement |
|---|---|---|---|
| 15–60 sec | Mastery; solve one more | Visible cause, fast replay, next contraption | next_level_tap, retries, rage_exit |
| 3–5 min | Variation and discovery | Every 3–5 levels an unexpected combination; workshop shelf reveal | completed_levels_per_session, gadget_diversity |
| Next day | Shared novelty | Daily Circuit 3 challenges; no punishing streaks | daily_start, daily_complete, D1/D7 |
| Weekly | A larger achievement | 12 preauthored weekly story packs | event_open, event_finish |
| Long-term | Ownership and friendly competition | 24 inventions, cosmetic workshop, medals and challenge links | workshop_visit, medals, invite installs |

## First session path

1. Launch → 3s Pip setup (skip-enabled) → level 1 with GO highlighted.
2. Level 1: one obvious intervention; early visible success; never request permissions before the first level.
3. Level 2: one placement with large snap slot.
4. Level 3: an optional fun failure teaches free rewind; highlight replay button.
5. Levels 4–5: introduce alternate outcomes and unlock first workshop item.
6. After level 5: optional workshop visit; no nag screens, no paywall.
7. Leave a visually understandable next puzzle unfinished but **do not** nag or penalize leaving.

## Unlocking

- World 1 available immediately. World N opens after previous world level 16 clear; last four previous-world levels are challenge chapters. This avoids hard progression roadblocks.
- Level unlock chain primarily linear; players can revisit levels and use a free chapter assistance skip when stuck repeatedly. An assistance skip counts as reached, not cleared.
- Every four normal level clears earns one invention fragment; four fragments unlock one of the current world's four inventions. Extra medals and dailies can accelerate cosmetic-only unlocks but cannot buy gameplay advantages.

## Cosmetic-only currencies

- Currency name: **Screws** (not real money). Main level first clear = 10 screws; first time each optional medal = +5; Daily Circuit first completion = 30; weekly pack completion = 80. No repeatable exploit farming per same level/day.
- Prices: sticker 50–120; bench paint 150–300; Pip accessory 200–400; victory confetti 350–500; rare themed workshop decor 600. Prices are tuning defaults, NOT guaranteed economic balance.
- Earn/spend to be reviewed based on actual pace. Never make players watch advertisements to obtain basic personalization.
- All unlocks and rewards must persist across updates; duplicate claims must be idempotent. No negative balances or client-trust real-money entitlements.

## Medals and goals

- One mandatory Rescue medal; 0–2 optional challenges per level, objective names and conditions serialized in level data.
- Rewards only on first clear; later personal best updates records without uncapped currency printing.
- If a 'no rewind' medal unfairly disadvantages users who rely on accessibility mode, include alternative equivalent earned condition rather than excluding them.

## Daily Circuit selection

- Use curated manifest with 90 distinct **design briefs** (30 days × 3 slots) initially, to be built, played, and verified before launch. Rotate 3 daily slots from validated pools by UTC date. This is an authored rotation, not an unsolvable random generator.
- Slot A: easier Fix It; slot B: mid Save It; slot C: harder Combo. All users receive same IDs per UTC day.
- If device offline, use deterministic local schedule; if device clock is suspicious, allow play but defer score submission (if online leaderboard is ever added).
- Missed content archive is playable later; first completion bonus available once per scheduled date. No streak-based loss.

## Weekly events

- 12 event packs with three stages each (36 authored curated missions or event variations). Four episodes may reuse geometry with different validated intervention conditions, but no automated release of untested variants.
- Each event earns a themed cosmetic, not a power boost. Archive makes content revisit-able, but first-week trophy may be date-labeled rather than exclusive gameplay.
- No server required: events are bundled; news or future updates can add packs in app releases.

## Ethical play and retention

- Explicit session-break support, no guilt copy, no false scarcity, no manipulative close dialogs.
- Notifications opt-in only after return behavior established; max one relevant daily challenge notification per 24h, easy to disable. Default off, do not request notification permission on first launch.
- Respect accessibility/motion sensitivity; speed settings, contrast markers, captions and reduced motion.

## Experiments and dashboards

- Experiment A: timing windows (generous vs slightly tighter) measured by rage-exit and level continuation, not just duration.
- Experiment B: workshop reveal timing measured by repeat sessions and session completion.
- Experiment C: show optional free hint after 2 vs 3 failures measured by quit and success.
- Experiment D: interstitial policy off vs conservative frequency, guardrails D1/D7 and crash-free users.
- Randomize at install ID locally; no PII; expose assignment through analytics. Do not tweak difficulty or ads covertly in a way that unfairly changes ranking within daily challenges.

## Guardrails

- Do not increase forced ad impressions if D1 retention drops materially in a controlled comparison.
- If 20%+ of players repeatedly fail a level 5+ times, flag design review; this is an alert threshold, not a magic benchmark.
- If the next-level click rate drops sharply at one stage, audit its clarity and length.
- Consider actual lifetime revenue per install and return-on-acquisition spend before marketing scale.
