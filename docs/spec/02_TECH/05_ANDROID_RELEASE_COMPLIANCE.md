# Android release, Play policy and build correctness

**Verified on 2026-10-29. Recheck these sources at release; Google and SDK policies change.**

## Policy facts

- **New/updated Play apps:** As of 2026-08-31, new standard mobile Android apps/updates must target **Android 16 API 36+**. (Source: https://support.google.com/googleplay/android-developer/answer/11926878)
- **Disruptive ads:** Google Play prohibits unexpected full-screen advertisements during gameplay or at the beginning of a level/content segment. (Source: https://support.google.com/googleplay/android-developer/answer/9857753)
- **Ads integration:** Poing Studios AdMob plugin v5.1.0 stable shown 2026-09-13. Godot 4.5+ and minSDK 24 or higher are documented in latest setup; verify compile/target SDK 36 build. (Sources: https://github.com/poingstudios/godot-admob-plugin/releases ; https://poingstudios.github.io/godot-admob-plugin/)
- **Billing:** Godot's first-party Google Play Billing plugin documented for 4.2+; verify Billing version against currently enforced Google Play requirements at integration time. (Source: https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html)

## Platform build settings

1. Set bundle ID placeholder to `com.yourstudio.tinychaos` until owner supplies release package ID (don't claim an invented ID belongs to the owner).
2. Godot 4.7.2 stable, export template same build, GDScript, Android Gradle build template, JDK 17 compatibility; SDK platform API 36 or higher, `targetSdkVersion=36` (or later required), `compileSdkVersion` sufficient, minSDK 24+.
3. ABI arm64 mandatory; 32-bit ARM optional if supported by plugin and measured performance. Android App Bundle (`.aab`) release signed with keystore held by owner; debug APK separate.
4. Test icon and adaptive icon, splash, immersive bars/insets, foreground background, audio focus, locale, rotation lock, screen sleep, gestures.
5. Validate native plugin permissions, ads SDK attribution, UMP consent, Play Billing purchase flows, deep-link App Links (verified host).
6. Configure store listing: screenshots from real gameplay; no misleading ad footage; privacy URL; Data safety and advertising declarations; age rating/target audience; financial payments; testers and rollout.

## Release gates

- Campaign: 120 scenes **validated**, six worlds, each with ≥1 clear trace; no blocking level bugs, no inaccessible input.
- Daily 90 designed missions AND event content converted to validated runtime assets; schedule references release-approved assets only.
- All requested localization languages completed and inspected on mobile or intentionally scoped down with owner approval before release.
- Ads: UMP region handling, test ID QA, disabled/no-fill path, ad frequency caps, child-targeting review and privacy choices.
- Billing: `remove_interstitials` purchase & restore tested through Play test tracks; correct pending/cancel/refund behavior; owner configured product IDs.
- No ad occurs after fail/rewind or before a level starts; telemetry present and consent-aware.
- Functional save migration and no data loss on force kill/restart; offline gameplay works.
- Performance evidence on at least one low/mid and one higher Android device; crash-free internal/closed test; accessibility settings tested.
- Store graphics built and published under legitimately owned branding; trademark clearance and user-facing privacy policy.

## Internal/closed test checklist

- Installation from Play internal track; signed AAB install; app opens on clean device.
- Billing uses Play license testers and test products, not `adb install` alone.
- AdMob test devices enabled; confirm Ad Inspector network diagnostics; never click own production advertisements.
- Launch privacy forms with representative consent regions or debugging test setup.
- Stop ship if any security/privacy policy issue, uncontrolled ad placement, irreversible save corruption, level softlock, active purchase entitlement failure, or critical accessibility barrier.

## Source links

- https://godotengine.org/download/archive/4.7.2-stable/
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
- https://support.google.com/googleplay/android-developer/answer/11926878
- https://support.google.com/googleplay/android-developer/answer/9857753
- https://github.com/poingstudios/godot-admob-plugin/releases
- https://docs.gameanalytics.com/event-tracking-and-integrations/sdks-and-collection-api/game-engine-sdks/godot/
