# Verified free-asset candidates and practical download plan

**Research date:** 2026-10-29. Source listings were checked for stated free/commercial-friendly licenses. This ZIP contains **links and production guidance, not downloaded third-party asset binaries**. License statements were read at the linked publisher/asset pages and must be re-verified at actual download/usage time.

**Best fit:** Kenney (CC0) for legal-clean source mechanical parts, prototypes, background texture, interface elements and SFX. OpenGameArt individual *CC0-only* mechanical SFX may supplement. Google Fonts Fredoka (OFL) supports the playful headline type. Quaternius CC0 optional 3D props; style-match via re-materialization in Blender.

## Highest-priority download shortlist

| Source | Best role | License on source page | URL |
|---|---|---|---|
| Kenney Factory Kit (140 3D files) | Conveyor, crates, base machine part sources | CC0 | https://kenney.nl/assets/factory-kit |
| Kenney Physics Assets (215 2D files) | Ramps, geometric physics objects | CC0 | https://kenney.nl/assets/physics-assets |
| Kenney Rolling Ball Assets (60 2D files) | Ball visual/test collisions | CC0 | https://kenney.nl/assets/rolling-ball-assets |
| Kenney Toy Car Kit (100 3D files) | Wheels, toy mechanisms, body panels | CC0 | https://kenney.nl/assets/toy-car-kit |
| Kenney Brick Kit (290 3D files) | Plastic toy construction props | CC0 | https://kenney.nl/assets/brick-kit |
| Kenney UI Pack (430 files) | Buttons, frame panel placeholders | CC0 | https://kenney.nl/assets/ui-pack |
| Kenney Game Icons (105 files) | Input prompt base icons | CC0 | https://kenney.nl/assets/game-icons |
| Kenney Particle Pack (80 files) | Spark/confetti inspiration, runtime effects | CC0 | https://kenney.nl/assets/particle-pack |
| Kenney Impact Sounds (130 files) | Bounces, collisions, soft hits | CC0 | https://kenney.nl/assets/impact-sounds |
| Kenney Interface Sounds (100 files) | Reward, select and confirmation | CC0 | https://kenney.nl/assets/interface-sounds |
| Kenney Music Jingles (85 files) | Short reward jingles, temporary sound ideas | CC0 | https://kenney.nl/assets/music-jingles |
| OGA Mechanical Sounds (BMacZero) | Ratchets, levers, squeaks | CC0 | https://opengameart.org/content/mechanical-sounds |
| OGA Clock Wind Sounds (BMacZero) | Winding machine sounds | CC0 | https://opengameart.org/content/clock-wind-sounds |
| OGA Squeak Toy Sounds | Comic impact sounds | CC0 | https://opengameart.org/content/squeak-toy-sounds |
| Fredoka (Google Fonts) | Friendly headlines | OFL (include license notice) | https://github.com/google/fonts/tree/main/ofl/fredoka |

## Supplementary candidates

- Kenney Emotes Pack: https://kenney.nl/assets/emotes-pack — CC0, 480 emote icons.
- Kenney Background Elements Remastered: https://kenney.nl/assets/background-elements-remastered — CC0, 90 shapes.
- Kenney Pattern Pack: https://kenney.nl/assets/pattern-pack — CC0, 80 textures.
- Kenney City Kit Industrial: https://kenney.nl/assets/city-kit-industrial — CC0, 40 models.
- Kenney Platformer Pack Industrial: https://kenney.nl/assets/platformer-pack-industrial — CC0, 110 2D files, mostly strong silhouettes but may conflict with chosen perspective.
- Kenney Shape Characters: https://kenney.nl/assets/shape-characters — CC0, reference/prototype only (make Pip original).
- Kenney Smoke Particles: https://kenney.nl/assets/smoke-particles — CC0, 70 effects.
- Kenney Prototype Textures: https://kenney.nl/assets/prototype-textures — CC0, test art only, not intended for polished release.
- Quaternius Modular Platformer Pack: https://quaternius.com/packs/modularplatformer.html — CC0, 53 low-poly 3D models.
- Quaternius Simple Nature Pack: https://quaternius.com/packs/simplenature.html — CC0, optional world backgrounds (must match style).
- OpenGameArt Quick Drill Fix: https://opengameart.org/content/quick-drill-fix — CC0, robotic squeak.
- OpenGameArt Mechanical Explosion: https://opengameart.org/content/mechanical-explosion — CC0; probably too harsh for general use; trim/mix appropriately.
- Kenney UI Audio: https://kenney.nl/assets/ui-audio — CC0, 50 short cues.
- Kenney Puzzle Pack 2: https://kenney.nl/assets/puzzle-pack-2 — CC0, 795 2D puzzle assets useful for test fixtures.

## Licensing and practical cautions

- **CC0** generally permits commercial use and modifications without required attribution; still retain provenance and give courtesy credits in an in-game credits screen.
- **OFL** permits use and bundling fonts subject to license conditions; include the actual `OFL.txt` with distributed font resources and obey Reserved Font Name restrictions if modifying/renaming fonts. Do not assume logo/typeface trademark rights.
- **Quaternius:** Some newer packs expose only 60–70% of models in a free 'Standard' tier; only download what is genuinely available for free. Each pack page is authoritative, not general marketing claims.
- **OpenGameArt:** Mixes several licenses even inside collections; use the **individual CC0-listed item page**, not a whole collection indiscriminately. If an asset says CC-BY, GPL or unclear license, get legal/attribution approval or skip.
- **Kenney downloads:** Many pages allow a legitimate 'Continue without donating' flow. Follow publisher UI; record the exact pack release/version/hash after downloading. If automated download is blocked, use manual/browser action rather than unverified mirror links.
- **Avoid** copyrighted character sprites, trademarks, ad music samples, sound clips from YouTube/social media, or 'free' content with noncommercial-only terms.

## Agent download/selection procedure

1. Open canonical page; capture title, publisher, asset version, on-page license, URL and date.
2. Download legitimately; unzip under `raw_assets/<publisher>/<pack>/` outside the game tree.
3. Scan archive for included license or README; compute SHA-256 for downloaded ZIP and reused source files. Update `asset_sources.csv` & `LICENSE_LEDGER.csv`.
4. Preview contents and choose a few **cohesive assets**; re-materialize and bake custom 2D sprites in Blender to match the art bible. Don't dump all raw packs into shipping game.
5. Export using agreed naming conventions and formats, compress, add to game atlas, test import and Android rendering.
6. Add courtesy credits, required notices, and final source list to app About/Credits and release repository.

## Other verified official sources

- Godot Ads integration: https://github.com/poingstudios/godot-admob-plugin (MIT; plugin code license separate from Google Mobile Ads SDK terms).
- Godot Google Play Billing: https://github.com/godot-sdk-integrations/godot-google-play-billing (open source; follow repository license and Play Billing policies).
- Godot GameAnalytics SDK: https://docs.gameanalytics.com/event-tracking-and-integrations/sdks-and-collection-api/game-engine-sdks/godot/ (SDK terms/API keys separate from art licensing).

**Asset source table (`asset_sources.csv`) is machine-readable and authoritative for the agent's download queue.**
