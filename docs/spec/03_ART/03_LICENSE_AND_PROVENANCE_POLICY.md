# Asset licensing, provenance and publication gate

## Before downloading

Allowed by default: original self-created assets; CC0 sound/2D/3D from the individually verified official publisher page; OFL fonts with bundled notices and any naming conditions. Other licenses require explicit license review and documentation before inclusion.

## Records required for each final asset

Each shipped file needs: logical_id, exported_file, original_source_file, source URL, publisher/author, declared license, source-pack version, retrieval date, archive/file SHA256, modifications, creator/agent, credit text/notice location, legal status, QA screenshot reference. Save to `LICENSE_LEDGER.csv` and package a separate `THIRD_PARTY_NOTICES.md` in the real project.

## Final review

- All CC0 packs have exact canonical download evidence and license state saved.
- Fonts ship with OFL notices, any required copyright headers and correct modified font naming.
- Blender/Illustrator creations marked original (unless derived); traced source links preserved for derived assets.
- No downloaded preview images, logos, app icons, brand names or marketing screenshots copied from competitors.
- If a requested source is free only for personal use or its author cannot be determined, replace it with original artwork.
- If any package contains unreviewed mixed-license files, extract only audited and clearly licensed files or exclude entire package.
- No copyright warranties are inferred from generative tools; audit final outputs and potential recognizable similarities.

## Release-safe source traceability

- `asset_sources.csv` contains **candidate pack URLs**, not bundled/downloaded file claims.
- `LICENSE_LEDGER.csv` begins with row status `CANDIDATE` and empty hashes. The agent must fill it after actual download and derivation.
- Game credits can optionally thank CC0 creators; preserve legally required notices for OFL or any later-approved assets.
