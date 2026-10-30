# The six-world campaign: production content bible

**Release campaign is 120 playable, individually QA-approved levels; the 120-row CSV is the level brief queue, not finished playable scenes.** The agent must translate these briefs into puzzles with art, geometries, cues, physical interactions, scripted outcomes, winning traces, optional medals, and Android clearance evidence.

## World map and audience experience

| World | 20-level arc | Mechanical introduction | Finale expectation | Collectible inventions |
|---|---|---|---|---|
| 01 Workshop Wake-Up | Learn cause-and-effect and rewind | ramps, springs, switch, flipper | Pip wakes a finished toy machine | Alarm Bot, Spoon, Toolbox, Duck Elevator |
| 02 Candy Catastrophe | Understand moving belts and airflow | conveyor, bumper, fan | Finish a ridiculous dessert | Donut Drone, Carousel, Candy Mixer, Marshmallow Lift |
| 03 Sky Lab | Trajectories and active timing | fan, platform, propeller | Guide a science trophy home | Glider, Sky Bus, Cloud Umbrella, Wind Tunnel |
| 04 Magnet Mischief | Polarity and changing routes | magnet, switch | Assemble a robot with toy electromagnet | Compass Bot, Polarity Globe, Swan, Sculpture |
| 05 Clockwork Carnival | Multiple actuators and rhythmic decisions | seesaw, flipper, wheel | Finish a silly carnival machine | Ferris Wheel, Clockwork Clown, Pinball Orchestra, Bell Tower |
| 06 Moonshot Mayhem | Advanced relationships and unusual gravity | portal, gravity zone, field effects | Light up the miniature toy universe | Rocket Tea Kettle, Donut Machine, Moon Rover, Star Launcher |

## Level beats in each world

- **1–3**: teach mechanic, reveal outcome clearly, forgiving controls.
- **4–6**: introduce second action/variation, preserve 30–45s typical clears.
- **7–10**: remix paths, introduce one memorable funny failure and first optional alternate solution.
- **11–15**: add novel combinations with a single visible twist per level.
- **16–19**: more challenging skill/strategy combinations; never require pixel-perfect physics.
- **20**: accessible multi-stage finale with 2–3 connected causes, but clear checkpoints and skippable animation. No level should soft-lock campaign.

## Recipe types (avoid pure repetition)

1. Missing link: select the one connection piece that completes a route.
2. Timed rescue: observe cue and activate one lever before a hazard.
3. False shortcut: easy-looking route leads to harmless comedy failure; alternate route can be reasoned out.
4. Dual outcome: rescue Pip and optionally collect a bonus prop.
5. Shape variation: different projectile sizes/materials force altered gadget choice.
6. Direction flip: alter wind/polarity/gravity direction to reverse fate.
7. Sequence: prepare a route, then intervene again at a checkpoint.
8. Efficiency: fewer actions produce a stronger medal; basic clear remains accessible.
9. Cooperative machine (not multiplayer): two gadgets interact unexpectedly but predictably.
10. Finale: three planned stages that each teach and reuse a mechanic, not an unpredictable avalanche.

## What makes a level *actually authored*

Each level's implementation must include:

1. A storyboard (start, problem, player agency, success, comic fail) and mobile camera frame.
2. Actual positions/colliders and gadget states, no unreachable or ambiguous interaction targets.
3. A documented guaranteed winning solution (recorded actions/ticks), verified on a phone.
4. A reason why the wrong/late action fails, clear from game feedback.
5. One optional fair medal route + a second medal if feasible, separately tested.
6. Skippable event animation and restore checkpoint integrity.
7. A meaningful distinction from the previous several levels in objective/skill or gadget relation.
8. Android profiling for any multi-body levels; performance record and test signoff.

## Difficulty rubric

- Tier 1: one choice, no execution pressure; intentional success achievable after first impression.
- Tier 2: one meaningful wrong alternative or generous 1-second timing window.
- Tier 3: 2 mechanisms; checkpoint located before second action.
- Tier 4: multi-route reasoning; alternative medal changes strategy.
- Tier 5: 2–3 stage route but never hidden input or sub-200ms compulsory timing windows.

## Source-data usage

`LEVEL_DESIGN_PLAN_120.csv` defines premise, unique name, core action design and world structure; avoid blind generating the same scene with only title changed. The scripts/fixtures in `example_levels` are *layout syntax demonstrations*, not valid finished puzzle geometry. The implemented build must contain final resources for every ID and an index that produces a 120/120 QA count.
