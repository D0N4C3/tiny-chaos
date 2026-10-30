# Custom Blender MCP production — original game artwork

**Purpose:** a cohesive set of toy-diorama renders that become 2D sprites in Godot. Do not interpret reference screenshots as permission to copy existing games. Discover the actual Blender MCP tool schema at run time; the instructions here are natural-language tasks, not fabricated tool commands.

## Global Blender job specification

- Scene uses orthographic camera, consistent 3/4 side view mapped to 2D physics gameplay plane; use one world-unit to pixel scale conversion. Fixed camera tilt and lighting rig reused across every object.
- Models: original low-poly rounded toy shapes, bevel edges, clean silhouettes, warm ambient shadow, matte plastic / warm wood / light metal palette from art bible.
- Format: save native `.blend`; for selected editable models export `.glb` if needed; for runtime export transparent alpha PNG sprite(s) or WebP with stable pivot and collision reference; sprite atlas trimming metadata.
- Output standard: main object render at 1024px square for high-resolution original (runtime atlas reduced as necessary), alpha transparent, centered with margin. Animation sequences in numbered frame folders; no hard-baked background shadows in gameplay hitboxes.
- Design collider reference overlay separate from beauty render, as colored primitive shapes to ensure Godot physics match. Do not use real-time 3D in final levels unless performance approved.

## Exact artwork jobs (priority order)

| ID | Original deliverable | Specs | Animation / variants |
|---|---|---|---|
| BL-01 | **Pip robot base rig** | Round body, asymmetrical antenna tipped in glowing square, teal chevron badge, small telescoping arms/legs; original proportions and personality | base rig, idle, blink, surprised, wobble, success, wave, foam splash |
| BL-02 | Ball family | Painted wooden, glassy candy and magnetized steel balls | 3 materials × 4 colors; rolling normals/lighting cues |
| BL-03 | Spring launcher | Compressible coil spring with clear force-direction arrow and wide base | idle/compress/fire/recover 10 frames |
| BL-04 | Fan + blades | Toy desk fan, exaggerated translucent airflow stream in separate VFX | idle/spin/high/low, 2 colorways |
| BL-05 | Magnet | U-shaped strong silhouette, embossed +/- pole markers | idle/attract/repel active halos |
| BL-06 | Seesaw | Wooden rocking lever with oversized hinge, damping visual | rest/left/right/impact |
| BL-07 | Flipper | Springy arcade paddle with cartoon impact face | idle/active, left/right mirroring allowed |
| BL-08 | Conveyor | Sectional toy belt, clearly directional rollers | 4 orientations, moving looping texture strip |
| BL-09 | Portal | Framed toy hoop with inner light aperture and direction code | powered, idle, transition sprite |
| BL-10 | Gravity ring | Suspended coil with compass arrows and gravity particle field | 4 direction indicators |
| BL-11 | Switch and timers | Big forgiving touch lever and circular countdown dial | red/green states with icon overlays |
| BL-12 | Goal props | Robot safe landing pad, donut target, paint pot, toy rocket dock | 6 goal silhouettes |
| BL-13 | Fail-safe props | Foam vat, cushioned cloud, paint bucket, balloon | 6 comic nonviolent reactions |
| BL-14 | Workshop kit | Wood bench, pegboard, shelves, tool rack, labels, lamp | 4 modular skins + blank slots |
| BL-15 | 24 collectible inventions | Four per world: see cosmetic collection table | idle 2–4 frame motion each |
| BL-16 | World 1 diorama | Warm workshop platform background and foreground | 3 variants |
| BL-17 | World 2 diorama | Candy conveyors / frosting tubes | 3 variants |
| BL-18 | World 3 diorama | Wind tunnels / cloud props | 3 variants |
| BL-19 | World 4 diorama | Magnet play lab / polarity rails | 3 variants |
| BL-20 | World 5 diorama | Carnival clockwork / pinball toy stage | 3 variants |
| BL-21 | World 6 diorama | Space-themed toy stage / planetary props | 3 variants |
| BL-22 | Reward props | Sculpted screws, stickers, badges, medals, tokens | idle/reveal/spin |
| BL-23 | Title/key art | Original composition showing Pip saving a flying donut through a chain reaction | square/portrait/landscape crops |
| BL-24 | App icon base model | Pip + spring + characteristic antenna, bold 1 object composition | adaptive icon foreground/background |

## MCP job prompt template (adapt for each ID)

> Create an ORIGINAL stylized toy-diorama 3D asset for mobile game Tiny Chaos. Use the attached art bible palette. Use rounded low-poly geometry, strong silhouette at 64 px, slight bevels, matte painted plastic, warm soft shadow, fixed orthographic 3/4 camera, consistent scale/pivot and zero copyrighted references. Deliver editable `.blend`, PNG alpha render(s), four-angle preview contact sheet if useful, collider guide, named objects, animation frames if specified and a metadata note. Do not include stock watermark, background, unnecessary high-poly topology or brand logo. Verify output in Godot 2D at final on-phone scale.

## Validation and handoff

- Keep source `.blend` per asset ID; add source provenance and preview sprite contact sheet under asset version folder.
- Verify orientation, pivot and collider overlay; run animation strips in Godot with reduced-motion alternative.
- Render key states with same light rig and same export scale to avoid mismatched art.
- Give Pip its own distinct silhouette and trademark-cleared name before release.
