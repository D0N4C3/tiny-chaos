# Custom Illustrator MCP vector artwork — original UI and marketing

**Purpose:** original, consistent vector language for all UI/menus, icons, wayfinding, medals, captions, share cards, store assets, and text-safe signage. Discover connected Illustrator MCP tool schema at runtime; never assume a particular bridge command.

## Global vector direction

- Rounded corners, playful geometric 2–3 px equivalent strokes, accessible contrast against cream/soft brown; no spiky dark factory style.
- Organize each file with named artboards, consistent 8pt grid, editable vectors, strokes expanded only at export as needed, correct pixel alignment.
- Export editable `.ai` or SVG source when supported plus optimized SVG/PNG runtime files. Confirm safe Godot SVG support; rasterize effects that do not render correctly.
- Exclude brand names, stock logos or copyrighted character lookalikes; typography uses licensed Fredoka for headings (with OFL notice) and a neutral body companion from a verified OFL family.

## Production jobs

| ID | Artwork | Required outputs |
|---|---|---|
| IL-01 | Tiny Chaos title lettering & emblem | Original logotype, horizontal+stacked, light/dark, SVG/PNG, trademark search note |
| IL-02 | Core game HUD | GO, Pause, Rewind, Restart, Hint, gadget selection, disabled/pressed/focus states |
| IL-03 | Gadget pictograms | 12 high-contrast icons with direction and active state, never color-only |
| IL-04 | World badges | Six original miniature world icons, locked/unlocked/complete |
| IL-05 | Medal system | Rescue / Precision / Inventor badges and empty variants |
| IL-06 | Workshop and economy | Screw currency, furniture category, paint swatch, shelves, purchase states |
| IL-07 | Daily Circuit | Three mission badges, UTC day indicator, archive tab |
| IL-08 | Weekly Lab | Episode tiles, archive labels, reward panels |
| IL-09 | Shareable challenge card | 1080×1920 story template + 1080×1080 square, clean central gameplay photo window, no fake score |
| IL-10 | App Store screenshots framing | 5–8 brand frames with truthful feature copy and space for real captured gameplay |
| IL-11 | App icon and feature graphic overlays | Android adaptive icon layers + 1024 source; 1024×500 feature-graphic layout with genuine art |
| IL-12 | Accessibility symbols | Shapes for polarity, hazard, goals, direction and interaction cues |
| IL-13 | Tutorial pointer overlay | Finger prompt, arrows, snap circles, no text dependency |
| IL-14 | Dialogue/feedback speech bubbles | Success/failure/hint, scalable bubble background |
| IL-15 | Credits/legal screens icons | Information, privacy choices, language, accessibility and sound |

## Suggested execution prompt

> Develop original vector UI artwork for a polished portrait mobile physics-comedy game called Tiny Chaos. Use the art bible's cream/coral/mint/sunny/sky palette, rounded tactile buttons and 48dp minimum touch target guidance. Draw from scratch; do not copy App Store screenshot UI, Kenney images or competitor logos. Create named Illustrator artboards with independent states, editable paths, icon outlines that remain legible at 24dp and alternate high-contrast variations. Export SVG sources and high-quality runtime PNGs; include a preview sheet and sizes. Verify the paths, readability and colorblind-safe icon forms in the actual Godot game.

## Asset acceptance

- Original branding is memorable at 48×48px and not confused with similar game apps.
- Icons recognizable without hue distinction; text remains legible in all release languages.
- Share cards contain a real frame captured from the game and a valid challenge ID, not fabricated ads or leaderboard stats.
- UI source files and export directory have consistent asset IDs matching `ART_PRODUCTION_TRACKER.csv`.
