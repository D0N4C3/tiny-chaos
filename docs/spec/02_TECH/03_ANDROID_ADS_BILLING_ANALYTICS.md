# Native Android integrations — pin, verify, smoke-test

## Integration baseline (verified sources 2026-10-29)

| Component | Selected path | Critical validation |
|---|---|---|
| Godot | Stable 4.7.2, GDScript | Pin editor and export templates |
| Android build | Gradle template / SDK, JDK17 baseline | AAB target API 36+ (mandatory for new Play submissions Oct 2026) |
| Ads + consent | Poing Studios Godot AdMob Plugin **v5.1.0** (latest stable listed Sept 2026) | Check engine min 4.5, target/minSDK, UMP, AdMob next-gen SDK, Ad Inspector, test ads |
| In-app purchases | Godot Foundation `godot-google-play-billing` official integration | Version compatible with Godot 4.7.2 and current Billing Library, test purchases + restore |
| Analytics | Official GameAnalytics GDExtension for Godot 4.5+ | Editor mock + Android event delivery + offline safe |
| Crash signals | Godot error logs / optional Android crash reporting | Integrate only with stable production-ready plugin; no invisible crash claims |
| Share | Android native share intent / platform integration; App Links | Correct intent chooser, assetlinks.json, verified domain + fallback |

## Source links

- Godot 4.7.2: https://godotengine.org/download/archive/4.7.2-stable/
- Exporting Android: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- Godot AdMob releases: https://github.com/poingstudios/godot-admob-plugin/releases
- AdMob docs: https://poingstudios.github.io/godot-admob-plugin/
- Billing source: https://github.com/godot-sdk-integrations/godot-google-play-billing
- Billing Godot docs: https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
- GameAnalytics official setup: https://docs.gameanalytics.com/event-tracking-and-integrations/sdks-and-collection-api/game-engine-sdks/godot/
- Play target API policy: https://support.google.com/googleplay/android-developer/answer/11926878

## Versioning caveat

Poing's latest documentation and older versioned pages differ in prerequisites (some mention compile SDK 35, others 36); the agent must pin v5.1.0 with its matching documentation and **actually build against target SDK 36**. Do not copy incompatible integration code or automatically upgrade to nightly. Test export on devices before authoring the full campaign.

## Ads adapter contract (pseudo-code)

```
AdsAdapter.initialize_with_privacy()
AdsAdapter.can_show_interstitial(context) -> bool
AdsAdapter.maybe_show_interstitial_after_result() -> void
AdsAdapter.show_rewarded(reward_opportunity_id, on_result)
AdsAdapter.disable_interstitials(entitlement: bool)
AdsAdapter.open_privacy_choices()
```

`on_result` statuses: `COMPLETED_REWARDED`, `CANCELED`, `NO_FILL`, `SDK_ERROR`, `NOT_ALLOWED`. Grant exactly once only on rewarded callback. Store opportunity and claim IDs; retries never grant duplicate rewards. Editor and offline no-op adapters return `NO_FILL` and do not block.

## IAP adapter contract

- `connect`, `query_products`, `purchase(remove_interstitials)`, `restore`, `acknowledge`, `entitlement_changed`.
- Handle pending, canceled, success, not-acknowledged, already-owned, refunded/revoked, client disconnect, app resume and reinstall.
- Nonconsumable purchase requires valid Play response; Play Console supplies true local prices. Local saved entitlement is a cache, not sole proof in all cases.
- No store links or purchases unless Play Billing test implementation verified.

## Analytics event model

Tracked events and parameters are in `05_EXECUTION/ANALYTICS_EVENTS.csv`. All events use approved allowlist, pseudonymous random install ID, consent-aware collection, no emails or real names. Useful funnels:
- first_launch → tutorial_started → first_clear → level_5 → workshop_open → return_D1/D7;
- level_start → action → failure → rewind → success → next;
- ad_eligible → loaded → shown → reward_granted and post-ad session exit;
- challenge_share → resolved deep link → challenge_start → challenge_complete.

GameAnalytics wrapper gracefully no-ops in editor. Do not send test traffic to production game keys; never store secrets in Git.

## App link setup

- Plan URL `https://YOUR_OWN_VERIFIED_DOMAIN.example/challenge/<code>`; owner must supply real domain. Static host serves web fallback and `.well-known/assetlinks.json` binding Android app package and signing cert SHA256.
- Before verified domain exists: share an image with short code and store search fallback; no fabricated working deep link.
- Challenge code should be a versioned, checksummed (not cryptographically trusted) encoding of curated level ID and non-sensitive best metrics, not arbitrary user-uploaded script or content.
- Android share sheet should support image/text gracefully even without installed WhatsApp or other social apps.
