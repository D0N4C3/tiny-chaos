# UX/UI map and accessibility specification

## Screen inventory and navigation

1. `Boot` → splash/first-open config checks → `Home` (Play main, Daily Circuit, Workshop, Weekly Lab, Challenges, Shop, Settings).
2. `World Map` → scrollable world cards (6) with medals and progress → `Level Select` (20 per world).
3. `Level Gameplay` → pre-level vignette (dismiss) → planning slot → GO → controlled chain → outcome/retry.
4. `Outcome Win`: Pip reaction, medals, screws earned, Next prominently; optional Replay/Share; interstitial eligibility assessed only after scene transitions safely to a result UI.
5. `Outcome Fail`: why/visual hint + large free Rewind and Restart, no ads; skip failure animation after first view.
6. `Pause`: Resume, Restart, sound/haptics, help, exit. Pausing stops physics and timers safely.
7. `Workshop`: shelf grid, invented machines, cosmetic swap, earned currency, theme customization.
8. `Daily Circuit`: three challenges, completion indicators and non-punitive archive.
9. `Weekly Lab`: themed episode chapters and archives; offline content.
10. `Challenge` opened from deep link: same curated level + score comparator (never misleading global leaderboard without backend).
11. `Shop`: cosmetic-only offers, `remove_interstitials` IAP, restore purchases, consent/privacy.
12. `Settings`: languages, audio/haptic, reduced motion, colors/symbol mode, larger controls, privacy/consent, credits, licenses, reset progress (with confirm).

## Layout targets

- Portrait canonical reference design at 1080×1920 with scalable content using anchors/containers rather than static pixel positions.
- Cover 19.5:9 to 20:9 devices and tablets; notch/cutout, gesture nav and keyboard safe zones.
- Main scene center 2/3, HUD top, GO/retry and interaction controls lower area; ensure one-handed thumb reach.
- Touch targets ≥48 dp (recommend 56 dp where possible), 8dp spacing minimum, labels/icons readable on 5-inch displays.
- Back navigation: pause during gameplay; back closes dialogs before exiting; do not silently lose an active run.

## Onboarding

| Level | Teach | Copy (English) | Validation |
|---|---|---|---|
| 1 | Press GO and rescue | `Tap GO!` | 80% without narration |
| 2 | Snap a spring | `Drag the spring here` | drop area visibly oversized |
| 3 | Free rewind | `Oops! Tap rewind and try again` | failure not punishing |
| 4 | Tap a fan during action | `Tap when the ball gets close` | generous window |
| 5 | Medal and workshop | `You made something!` | Next still obvious |

## Accessibility settings

- Gameplay objects use iconography: fans = airflow streaks, magnets = plus/minus poles, goal = outline and arrow; colors are never sole identifiers.
- `Reduced motion`: disable shake, parallax, flashes and nonessential particles; preserve informative animation.
- `Larger controls`: increase hitbox and UI hit areas, never reduce actual action timing tolerance.
- `Assistive timing`: optional 0.65x simulation during timing segments, with normalized achievement rules (not penalized by access feature).
- `Audio`: separate master/music/SFX sliders; 0 sound must not remove critical event cues (display captions/visual pulsing).
- `Haptics`: independent toggle; use restrained vibration on success, start/stop toggle and feedback; no long rattles.
- Localization source English; release languages planned EN / ES / PT-BR / FR / IT with native/cultural review; missing translations must fall back to English gracefully, not display raw keys.

## Failure and success feedback

- If failure is ambiguous, add an on-screen glowing cause-of-failure marker at the location, not a false 'unlucky' outcome.
- First failure reaction ≤2 seconds then skip; success reward ≤4 seconds before Next becomes available. Retry latency target ≤1s on midrange phone.
- Never hide Next, Back, Settings or Remove Ads behind a rewarded video, and never place an interstitial before a player-requested action such as Start Level.

## UX copy style

Witty, friendly and concise. Avoid guilt. Examples: "The donut escaped!", "Nice save!", "Try a later launch", "That magnet needs a little love". Avoid personalized commentary, manipulative scarcity, or excessive emoji.

## Complete user journeys to verify

- First install → tutorial → 5 levels → visit workshop → close and return offline.
- Returning player → finish daily circuit offline → local reward → no duplicate currency claim.
- Press share → Android chooser → another installed user opens challenge; recipient missing app sees reasonable fallback.
- Purchased remove-interstitials → reinstall → restore after Play connection; absence of network doesn't force ads on previously verified purchase if entitlement is cached.
- Privacy consent changed/withdrawn → appropriate ad request state; ads fail open into normal gameplay, not blocked startup.
