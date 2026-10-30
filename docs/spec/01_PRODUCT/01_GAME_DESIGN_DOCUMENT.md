# FULL GAME DESIGN DOCUMENT — TINY CHAOS: CHAIN REACTION RESCUE

## Elevator pitch

Tiny Chaos is a portrait-mode, one-finger physics puzzle comedy. Every machine is one disaster away from failing. The player spots the problem, places a small invention and/or intervenes while the chain reaction is running to save the lovable robot Pip. Failures are funny and immediately reversible; successes teach skills and produce collectible creations. The experience must be mechanically engaging **before** reward economies or advertising are added.

## Audience and position

- Primary: casual puzzle/physics players seeking 20–60 second challenges and tactile satisfaction; broad global Android audience.
- Secondary: viewers of clever short-video puzzle and chain-reaction content; players who like comparing friends' solutions.
- Positioning: *A tiny fix. A huge chain reaction.* Not a passive video, not a complicated sandbox builder, not an endless runner.
- Competition lessons: open-ended solutions can be engaging, but tiny object adjustments, unpredictable collisions, repeating sequences and disruptive ads drive frustration. Differentiation is intervention + rewind + comedic objectives + player-generated share moments based on curated puzzles.

## The player fantasy

"I can see exactly what's going wrong. Give me one gadget and I can turn this disaster into a ridiculous success." Later: "I can do it with fewer moves, save an extra item or pull off a perfect rescue."

## Core loop (20–60 s successful run)

1. **SPOT (1–3s):** Camera previews a miniature diorama with Pip's goal and a visible failure prediction; show a clear silhouette and the target.
2. **PLAN (2–12s):** Place or rotate an available gadget into one or two snap slots; no microscopic dragging. Some levels have no planning stage.
3. **RUN (2–15s):** Tap GO; a deterministic start triggers conveyor/ball/lever/character actions. Player may press and hold to slow motion only if enabled for that level.
4. **INTERVENE (0–3 actions):** Tap, hold or release one large interactive mechanism within a *fair* window. Early levels have generous timing; difficulty rises by combinations, not frame-perfect input demands.
5. **OUTCOME (2–5s):** Win: Pip reacts, machine completes a silly invention, satisfying audio/haptic payoff. Fail: visible and funny nonviolent mishap; rewind goes instantly to the relevant decision.
6. **PROGRESS:** Earn main clear; optional Inventor/Precision/Secret medals; workshop scrap and collectible progress; Next CTA immediately available; no ad on failed attempts.

## Three curated puzzle families

**Fix It** (35% target): pre-placement only. Player selects from 2–4 gadgets, positions/rotates within snap points, and starts the chain. Main engagement = causal reasoning; never purely trial-and-error due to unclear options.

**Save It** (40% target): real-time interaction only. Machine is running; player controls a visible lever, fan, magnet or timed switch with generous visual/audio cues. Main engagement = skill and anticipation; account for input latency.

**Chaos Combo** (25% target): 1 strategic placement + 1–2 interventions. Requires understanding cause and timing. Not introduced in the first few levels.

Share of formats is a design allocation to test and rebalance, not an empirical market fact.

## Character and world stakes

Pip is a tiny round inventor robot, expressive through eyes, antenna, hands and body squish. Comic outcomes: confetti, a paint splash, donut landing, spinning umbrella, bubble rescue, rocket misfire. Never depict injury, painful suffering or cruel punishment. The world is a tactile toy workshop made of colorful modular stages.

## Controls and affordances

- Tap GO, rotate lever, fire spring; drag to snap well-labeled slots. Holding a mechanism changes its state; releasing resets if level-defined.
- Each gameplay interactive has a minimum ~48 dp equivalent touch target, scalable for varying density; avoid simultaneous multi-finger controls.
- Snapping magnet radius scales to input device and camera zoom; preview ghost placement and line of action.
- Clear state colors AND symbols (not color alone). Use contrast, input buffering, optional reduced motion and no surprise screen shakes.
- Camera frames everything relevant to a decision; use pan only if needed. Ensure no blind-timing puzzles from off-screen hazards.

## Failure and progress rules

- Failure explanation must point to cause: "Fan too early", "Missed the spring", "Wrong route", but not spoil the answer. First repeated failure offers optional free visual guidance.
- Unlimited free instant retry and decision rewind. No energy, lives, fail timers or paid continue.
- Players progress after main objective only; optional medals do not hard-block the campaign. World unlocks by progression, with assistance/accessibility alternative for very difficult skill gates.
- Puzzles need one documented guaranteed clear independent of rewarded ads.

## Medal system

- **Rescue (bronze)**: completed primary objective.
- **Precision (silver)**: level-specific skill condition (e.g., avoid 2 failed taps, complete within 2 actions) with accessibility alternatives.
- **Inventor (gold)**: creative alternate condition, bonus collectible, or different route; human-verified reachable.
- Medals are independent optional achievements, not a pseudo-three-star score predicated on repeated grind.

## Invention workshop (meta)

- Each themed world contains four collectible inventions unlocked across levels and medals. 24 displayable launch inventions; separate event prizes.
- "Scrap" earned from clears/daily circuits purchases **only cosmetic** paints, workbench textures, decals, silly hats and victory effects. Scrap does not improve physics or make the campaign solvable.
- Workshop shelf slots are discoverable; tapping unlocked invention plays one short animation (skippable). Players can pin favorites to the home screen.
- Award rewards should support intrinsic play; cap constant pop-up sequences. No pseudo-gambling loot boxes by default; if randomized cosmetics are ever added, show transparent odds and obey store policies.

## Levels, pacing and content targets

- 6 worlds x 20 = 120 authored main stages (see `04_CONTENT/LEVEL_DESIGN_PLAN_120.csv`).
- World 1: Workshop Wake-Up (ramps, springs, big switches).
- World 2: Candy Catastrophe (conveyors, fans, bumpers, food delivery).
- World 3: Sky Lab (fans, platforms, trajectories, lift and fall).
- World 4: Magnet Mischief (attract/repel, direction changes, timing).
- World 5: Clockwork Carnival (seesaws, flippers, chained switches, rhythm).
- World 6: Moonshot Mayhem (portals and gravity-change controls, multi-stage combinations).
- Intro on level 1; each world starts with discovery then practice, remix, challenge and a delightful 'final contraption' at level 20.
- Track time-to-clear, time-to-first-win, retries, failures by mechanic, skip rate and exits per level. Retune outliers rather than introduce paywalls.

## Narrative and dialogue

- 5–15 seconds of optional nonblocking personality on opening a world; no long cutscenes.
- Pip uses small speech bubbles with fewer than 10 words; captions optional, no spoken-language dependency.
- Tone: warm, mischievous, playful. No forced sarcasm or repetitive canned dialogue.
- Sample lines (original): "That lever looks suspicious." / "The donut has left the building." / "I meant to do that. Mostly." / "Science says try again!"

## Daily, weekly and social

- Daily Circuit = 3 curated, prevalidated remixes (Quick Fix / Perfect Timing / Master Inventor) with shared UTC date, fair result comparison, offline availability.
- 12 authored weekly event packs at launch; week calendar rotates prebuilt content. No hard streaks or time-based deprivation; archives remain revisit-able after initial event window.
- Friend Challenge = share a curated puzzle with challenge ID and your score; recipients can solve on same level. No unmoderated content submission or chat for initial launch.
- Sharing should work as image/text even if verified App Links infrastructure is unavailable at first build; make domain link activation a separate release gate.

## Ad/in-app purchasing principles

- The game is fun without ads. No ads during a reaction, on retry/rewind, on level intro, before main menu or after every level.
- Conservative interstitial after the *result screen* based on minimum win and time caps, never during first onboarding session; remote-configurable kill switch.
- Rewarded optional: double cosmetic scrap / extra cosmetic reward / preview alternate nonessential workshop animation. Normal hints and retries always free.
- IAP `remove_interstitials` nonconsumable; reward videos remain voluntary. Set real prices in Play Console, not in source code.

## Key quality bar

- Tutorials understandable silently by 80%+ of first-time testers (product target, not measured fact).
- Instant retry to first actionable frame target ≤1 second on mid-tier Android.
- Simulations do not produce divergent win/fail results from identical input on representative device/engine configurations.
- D1 30–35%, D7 8–12% as ambitious soft-launch *decision thresholds*, not guarantees. No ad optimization that decreases lifetime value or retention net of revenue.

## Never include in launch scope

- Live competitive multiplayer, user-uploaded levels, chat, real-money random rewards, forced ad-based retries, energy refill timers, unvalidated algorithmic puzzle generation, or pay-to-solve boosters. These can add operational and compliance complexity without proving the core game.
