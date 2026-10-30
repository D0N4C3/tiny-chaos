# Data, save versions, configuration and privacy

## Local save model

`user://save_v1.json`, schema versioned and atomic written using a temporary file then replace, with checksum/backups. Fields:

```
{
 "schema_version": 1,
 "install_id": "locally_random_pseudonymous_id",
 "world_progress": {"W01": {"unlocked": true,"highest_reached": 1}},
 "level_results": {"W01_L001": {"cleared": true,"medals": ["rescue"],"best_actions": 1}},
 "wallet": {"screws": 0},
 "reward_claims": ["main:W01_L001:clear"],
 "workshop": {"unlocked_items": [],"equipped_theme": "base"},
 "dailies": {"2026-10-29": {"clears":[],"claimed":false}},
 "weekly_events": {},
 "settings": {"language":"en","sfx":1.0,"music":0.65,"haptics":true,"reduced_motion":false,"assistive_timing":false},
 "iap_cache": {"remove_interstitials": false,"verified_at_utc":""},
 "privacy": {"consent_choice_cached":"unknown","settings_last_viewed":""}
}
```

This is an illustrative schema; actual store product verification/consent state must come from SDK, not JSON alone. Never log personal data, raw purchase tokens or cryptographic secrets.

## Save semantics

- No double first-clear rewards; call `grant_once(key, amount)` atomically.
- User can replay solved levels to improve medals without duplicating base clear rewards.
- Save before entering result screen or triggering ad; handle process kill/crash/reboot mid-game.
- Durable backup on migration; when version mismatch happens, preserve prior data and produce a recovery path rather than silently wiping.
- Progress, workshop, control and audio settings work entirely offline.

## Configuration

- `config.default.json` versioned and bundled: ad caps, analytics enabled flags, world unlock thresholds, replay cap, fallback mode, no unsafe hidden purchases.
- Feature flags local defaults stable; optional remote config only when a verified provider SDK is present and user consent applies. Offline defaults must be safe.
- Never introduce a live service that blocks boot if unavailable.

## Privacy/consent

- Settings provides Privacy Choices, link to legally published privacy policy, personalization/audio/notifications options and `Delete local progress` with confirmation.
- Android permission surface minimal: internet if ads/analytics/deep-link fallback require it, notification permission only for opted-in notifications (if ever built), no location, contacts, camera or microphone required.
- Play target audience and AdMob COPPA/TFCD settings require owner review. Ads and analytics SDK may collect device/ad identifiers where allowed; disclose accurately in Data Safety, don't claim 'no data collected' without auditing.
- Clear privacy notice must accurately describe offline local state, share card generation, ads/IAP and analytics.

## Security requirements

- No arbitrary remote script loading from challenge IDs. Strictly validate codes against curated allowed list.
- Do not trust client input for real-money entitlements; use Google Play Billing and reconciliation logic.
- Gitignore credentials and keystore. Scan compiled artifact and repository for placeholder secrets and third-party SDK tracking permissions.
- Ensure sharing does not expose user install IDs, emails or private gameplay metadata.
