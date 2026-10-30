# PLAY STORE RELEASE CHECKLIST — agent + owner

## Pre-submission

- [ ] Validate unique cleared commercial name (`Tiny Chaos` is working title only) and rights to all assets.
- [ ] Verify Android target SDK requirement currently at or above API 36, and relevant Play policies as of actual submission.
- [ ] Prepare keystore securely and enable Play App Signing, no secret in Git.
- [ ] Export release `.aab`, verify architecture and exact target SDK, ensure Play Billing and AdMob packages intact.
- [ ] Create/store Play icon 512×512 PNG32 (max 1024KB), feature graphic 1024×500 24-bit PNG/JPEG; screenshots of actual final gameplay. Specs: https://support.google.com/googleplay/android-developer/answer/9866151
- [ ] Configure app category, content rating, target audience, ads declarations and Data Safety according to actual data and SDKs. Source: https://support.google.com/googleplay/android-developer/answer/10787469
- [ ] Publish legally accurate owned-domain Privacy Policy, contact details, support URL and license credits.
- [ ] Configure AdMob app ID, unit IDs, UMP/privacy choices, test device setup and production safeguards. Follow: https://github.com/poingstudios/godot-admob-plugin/releases
- [ ] Configure Play Billing nonconsumable product `remove_interstitials`, test purchase/restore on internal test track. Follow: https://docs.godotengine.org/en/stable/tutorials/platform/android/android_in_app_purchases.html
- [ ] Verify App Links against owned domain and Play signing certificate SHA256 or ship verified challenge-code fallback. Follow: https://developer.android.com/training/app-links/about
- [ ] Run device QA, localization review, and every P0 case in `QA_TEST_CASES.csv`.

## Submission and rollout

- [ ] Install AAB via Play internal track; test purchase, ads, consent, game state and share.
- [ ] Closed test with representative devices/geographies as access permits, record qualitative confusion and crash logs.
- [ ] Rollout gradually, monitor `first_clear`, D1/D7, app errors, ad no-fill, billing issues and abnormal level failures.
- [ ] Stop/rollback any build that corrupts saves, cannot restore purchase, shows ads at prohibited times or has severe platform crash.

## External owner inputs (not for AI to fabricate)

- [ ] Legal publisher/studio name; app display name; package ID.
- [ ] Play Console app and access, signing keystore / Play App Signing setup.
- [ ] AdMob app ID and production/test ad unit details.
- [ ] Play nonconsumable product ID, valid pricing, test accounts.
- [ ] Actual privacy policy / support hosted URLs, data practices reviewed.
- [ ] Owned domain and TLS hosting for verified challenge App Links (if desired).
- [ ] Age/target audience decisions, advertising disclosures, and approved launch locales.
