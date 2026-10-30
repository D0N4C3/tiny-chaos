# Monetization — conservative ad policy, full integrations and tests

## Revenue products at launch

1. **Interstitials:** optional frequency-controlled displays at a completed-level RESULT break only; never on failures, starting a stage, GO, rewind or in middle of gameplay. No forced interstitial during the first five main levels or first onboarding session. Test launch parameters: ≥4 completed levels since last shown AND ≥180s since previous full-screen ad; consider a max of 3 per session to start. Ads may be disabled by flag and by IAP. These are tunable hypotheses.
2. **Rewarded videos:** explicitly opted in by the player for 2x first-time cosmetic screws on selected rewards, optional extra cosmetic workshop item, or a special nonessential invention replay. Clear value before requesting ad; grant reward only from verified reward callback; retry in-app flow if ad unavailable.
3. **Nonconsumable IAP:** `remove_interstitials` permanently suppresses forced interstitials. Rewarded remains offered optionally. Use Google Play product data for local currency pricing; do not hardcode prices or pretend a purchase works without a Billing response.
4. **No subscription, loot box, deceptive ad skip, paid ability boosters or essential hint paywall.**

## Decision engine

```
interstitial_eligible = consent_ready
    && !paid_remove_interstitials
    && !is_first_session
    && main_levels_completed >= 5
    && wins_since_last_interstitial >= 4
    && seconds_since_last_interstitial >= 180
    && ads_sdk_initialized
    && interstitial_cached
    && user_currently_on_stable_result_screen
    && !child_or_unknown_policy_block
    && !offline_or_sdk_error
```

- Fire only after victory state committed. Show on the result screen at an understandable break; no autoplay before player's tapped Next launches the next stage.
- Reset counters on actual `ad_impression`, not on request or load. If ad fails or none available: show normal Next; never trap user.
- No ads on intro, tutorial rewind, menus, pause, failure, app open, daily challenge completion cinematic, or while an IAP/consent prompt is active.
- Rewarded callback needs transaction idempotency: `reward_granted` keyed by reward opportunity and response event; do not grant twice due to duplicate callbacks.
- Audio should pause/duck on app losing focus or ads being presented; recover safely after ad closes.

## Consent and policy

- Integrate Google User Messaging Platform per AdMob plugin for applicable regions; request consent status update, show forms when required, handle withdrawal/options in Settings, respect under-age flags and relevant regulations.
- Do not claim the game is suitable for children or set COPPA-directed treatment without a legally reviewed audience policy. Cute art can appeal to younger audiences; Play target-audience and ads declaration must reflect actual intended audience.
- Store policy prevents unexpected disruptive full-screen ads during gameplay or beginning of a content segment. Read current Google Play Ads policy again at launch.
- Privacy Policy and Play Data Safety entries must describe actual AdMob, analytics, IAP, optional share/link data and storage. Never silently collect location, contacts, or personal chat.

## Ad experiment and business metrics

Track: ads_available, request/load failures, impressions per DAU, rewarded opt-in and completion, ad retention split, IAP conversion, ad LTV per install, organic referrals, uninstalls after ads. Compare cumulative retention and ARPDAU; never optimize raw eCPM or ads/session alone. Segment by geography and acquisition channel without collecting exact GPS location.

## QA cases

- No network or ad fill: uninterrupted gameplay.
- Consent denied/required/withdrawn: correct behavior.
- SDK initialization delay: playable immediately.
- Reward callbacks missing or repeated: no lost/duplicated reward.
- User presses app back or rotates device while ad shown: pause/resume never corrupts level.
- Purchase succeeds, fails, is pending, is canceled, is refunded/revoked, is restored after reinstall: correct entitlement and UI state.
- Test units only during development. Real ad unit IDs supplied by owner near release, stored in build config; never fabricated.

## Official sources (verified 2026-10-29)

- Play Ads policy: https://support.google.com/googleplay/android-developer/answer/9857753
- Poing Studios Godot plugin: https://github.com/poingstudios/godot-admob-plugin
- Godot Billing: https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
