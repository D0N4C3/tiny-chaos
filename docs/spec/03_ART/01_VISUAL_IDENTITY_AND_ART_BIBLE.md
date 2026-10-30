# Visual identity and art bible — Tiny Chaos

## Art positioning

"Premium tactile miniature toy workshop meets slapstick physics comedy." A unique, original visual style: friendly rounded silhouettes, readable mechanisms, warm lighting, carefully restrained motion and expressive Pip animations. Not realistic factory machinery, not pixel art, not another generic asset-pack UI.

## Rendering strategy

**Godot 2D gameplay with baked 2.5D illustrations:** build hero/mechanisms/environments as simple 3D objects in Blender, render ortho sprites and keyframe strips to PNG/WebP with transparent alpha, import into 2D scenes and animate with Godot tweens or AnimationPlayer. Illustrator creates vector UI, pictograms, world signage, logos and linework. This preserves 3D material quality while keeping physics and gameplay lightweight on Android.

**Camera/geometry style:** side-facing 3/4 orthographic diorama, but **collision planes are pure 2D**. Players must visually understand which objects interact. When representing depth, use it for background only. Keep all active objects on one predictable play plane.

## Palette and surfaces

| Token | Color | Use |
|---|---|---|
| `ink` | #233244 | labels and outlines |
| `cream` | #FFF5E8 | base paper/toy background |
| `coral` | #F36E70 | hazards and emphasis |
| `sunny` | #FFC857 | primary CTA, springs, reward |
| `mint` | #66CDA8 | success, safety, unlock |
| `sky` | #66BCEB | air/wind features |
| `violet` | #A78BEA | magnet/portal magical-tech |
| `wood` | #A87D5F | boards and supports |
| `shadow` | #574D64 | soft outlines/shadows |

Every critical game indicator must use **shape + label** in addition to color. Contrast, visually impaired view, and reduced-motion compatibility are production acceptance tests.

## Material system

- Painted wood: slightly rounded edges, subtle grain, no photorealistic sharp splinters.
- Soft matte plastic and rubber: one controlled highlight, bold silhouette; pastel but saturated enough to read on a phone.
- Brushed toy metal: neutral warm grey and subtle reflection, never dark industrial grunge.
- Springs/mechanisms: strong animated silhouette, bright action-state indicator, not tiny real-world detail.
- Environment: cozy tabletop diorama, warm ambient shadows and fixed camera so physical paths read instantly.

## Character Pip (custom, required)

An original friendly rounded robot **not resembling any existing franchise mascot**. Proportions: head/body roughly 60% of total silhouette, simple wide display eyes, one asymmetrical antenna, two telescoping little arms, small feet, visible joint seams. 8 key expressions: idle curious, excited, concentrating, startled, wobble, painted, relief, goofy victory. Distinctive marker: slightly off-center antenna with square glowing bead, small teal chevron badge, cheeks that light up.

Animations: idle blink/bounce (8–12 frames), anticipation (6), success spin (12–16), float rescue (12), foam splash (10), disappointed wobble (8), workshop wave (12). Alternative frame counts fine as long as runtime weights good and animation is polished.

## Machine readability

- Every gadget has idle/armed/triggered/spent state; visible effect line shows its hit direction.
- Snap slots are warm white outlined hardware sockets with a pulsing ghost preview, not invisible interaction zones.
- Collision objects rendered high contrast against background; decorative objects visually recede.
- Branch choice uses bold indicators (`A`/`B`, arrow or icon) rather than subtle color changes.

## Six world themes

1. **Workshop Wake-Up** — pastel wood workbench, screws, desk lamp, brass-like toy levers. Warm cream / amber.
2. **Candy Catastrophe** — soft candy wrappers, glaze tubes, gumball tracks, playful conveyor belts. Coral / mint.
3. **Sky Lab** — clouds through cardboard windows, wind tunnels, fans, propeller contraptions. Blue / sky.
4. **Magnet Mischief** — felt/steel panels, polarity icons, neon purple magnetic fields. Violet / teal.
5. **Clockwork Carnival** — toy brass, velvet stage curtains, spinning wheels, pinball/carnival cues. Gold / red.
6. **Moonshot Mayhem** — miniature model-space station, soft ultraviolet and aqua, rings and portal gates. Indigo / mint.

## VFX and sound relationship

- Success: fast pop, twinkle, small confetti burst, Pip pose. Optional micro-camera squash on impact; camera shake disabled in reduced motion.
- Failure: paint splash/foam puff and Pip comically popping back to safety; don't obscure cause of failure or prolong restart.
- Rewind: reverse swoosh + few trailing ghost sprites, ~250–400ms; reduce-motion mode does a fade swap.
- No constant flashing or overwhelming particles; safe for repeated short rounds.

## Asset acceptance and ownership

- All hero/gameplay-defining art must be original: Pip, all gadgets, goal props, portals, workshop and store icon. Free packs may be repurposed for scaffolding, background or derived original art; don't ship a patchwork mix of incompatible styles.
- Editable origins `.blend`/`.svg`, rendered `.png/.webp`, atlas metadata, animation IDs, source/author/license if derived, revision, assigned task and QA screenshot.
- Never send users original font files; font sources stay internal to game asset pipeline subject to license conditions.
