# Sound design and haptics plan

## Sonic identity

A small harmonious toy studio: warm plucky mallets, gentle rubber pops, tuned springs, short woody clicks, satisfying metallic-but-soft mechanisms and quirky robot beep syllables. Avoid harsh alarm sounds, abrasive bass, sharp repetitive squeaks, generic AI-sounding loops and overly loud failure noises.

## Required SFX group

| ID range | Count (target) | Use | Suggested source |
|---|---:|---|---|
| SFX-001–015 | 15 | buttons, drag, snap, go, rewind | Kenney Interface Sounds CC0 |
| SFX-016–030 | 15 | impact, ball rolling, wood/metal, spring, fan | Kenney Impact Sounds CC0 |
| SFX-031–040 | 10 | mechanical wind, ratchet, portal, magnet | OGA Mechanical Sounds and Clock Wind CC0; custom mix |
| SFX-041–048 | 8 | Pip vocal chirps/expressions | **Original synthesized/sound-design cues**, no copied voices |
| SFX-049–056 | 8 | success, medal, workshop, daily reward | Kenney Music Jingles CC0 or custom micro-melody |
| SFX-057–063 | 7 | funny failure, foam splash, donut, cartoon rocket | OGA Squeak Toy CC0 + self-recorded/synthesized |

## Music

Custom original ambient loops to avoid mismatched licensed tracks:
- Home/workshop: 95–110 BPM light felt percussion/marimba, mellow chords, sparse memorable motif, seamless loop 40–70s.
- During levels: soft low-information instrumental bed at 90–105 BPM, sits under taps; sidechain/duck 4–8dB when chain reaction peaks.
- Daily/weekly: gentle rotating motif to distinguish special mode without urgency.
- Success: 0.6–1.0s tuned three-note cadence; failure: 0.4s warm funny downward turn, not a punishing buzzer.

Original composition only. Avoid asking an AI model to imitate an identifiable copyrighted song, performer or track. Keep source music sessions and usage rights.

## Implementation

- Separate `Music`, `SFX`, `UI`, `Pip` buses; volume saved independently, one-shot limiter and duplicate-click de-bounce.
- Preload critical <1s effects, compress loops efficiently, respect Android audio focus and background state.
- Silent visual alternatives for all timing cues; haptics optional and sparse: low intensity tap, success pulse, no repetitive buzz.
- Device QA with low-volume headset and phone speaker; no peak distortion or fatigue from 30+ rapid retries.

## Provenance links

- https://kenney.nl/assets/interface-sounds
- https://kenney.nl/assets/impact-sounds
- https://kenney.nl/assets/music-jingles
- https://opengameart.org/content/mechanical-sounds
- https://opengameart.org/content/clock-wind-sounds
- https://opengameart.org/content/squeak-toy-sounds
