# Definition of Done — measurable release contract

## Gameplay

- [ ] 6 worlds, 120 primary campaign IDs, no duplicates/missing IDs.
- [ ] Each main level has a playable Godot scene/resource, human-reviewed first win, Android replay evidence, readable goal/fail, restart/retry/rewind success.
- [ ] 12 distinct gadget types have working animations, hitboxes, collision and repair/reload coverage.
- [ ] Free retry/rewind/checkpoint available without ads/currency; no soft-lock across background/restore.
- [ ] All medals are realistically obtainable through verified paths; alternative objectives optional.
- [ ] Level onboarding is intuitive in silent playtesting, with no text-heavy tutorial barrier.

## Game completeness

- [ ] Home, world select, level select, gameplay, results, pause, workshop, daily, weekly, challenges, shop, settings and privacy screens complete.
- [ ] 24 collectible inventions and 48 total catalog cosmetics implemented, visualized and saved (inventions count included in catalog).
- [ ] 90 daily slot variants authored, verified and scheduled as 30-day UTC rotation; offline works.
- [ ] 12 episodes x 3 = 36 weekly missions validated with archives/rewards.
- [ ] Curated challenges can be shared/imported and score compared locally; no private user data in shared code.
- [ ] Save schema versioned and atomic; all player progress survives force quit and upgrades.

## Art, sound and accessibility

- [ ] Pip, hero machinery, UI, six world scenes and reward art are original/cohesive (not placeholder art), Blender/Illustrator editables retained.
- [ ] Every third-party art/sound/font file tracked and license-reviewed with notices.
- [ ] Music/SFX/haptics pleasant, quiet mode, reduced motion, larger controls and color-safe symbols tested.
- [ ] EN, ES, PT-BR, FR, IT UI strings translated and device-checked; no English raw keys for supported locales except deliberate fallback if a translation is missing and release signoff permits it.

## Commercial/platform

- [ ] Godot 4.7.2 pin; target Android API 36+; arm64 release AAB built/signed through owner-kept credentials.
- [ ] AdMob UMP/consent correct, test ad callbacks confirmed; no gameplay-interrupting interstitials; optional rewarded rewards idempotent.
- [ ] Official Google Play Billing remove-interstitials IAP test purchased, pending/refund and restored; production product ID owner-configured.
- [ ] Analytics event taxonomy instrumented/tested and privacy-compliant; user-facing policy and accurate Data Safety declaration drafted/reviewed.
- [ ] Share chooser, app link fallback and owned domain validation demonstrated or unresolved owner dependency called out.
- [ ] 129 QA scenarios executed with evidence and no unresolved P0 or P1 ship blockers.
- [ ] Store assets meet current Play spec and use actual game screenshots; metadata, release notes and test track ready.

**Status policy:** `Done` requires specific screenshot, test log, trace, commit, compiled artifact or approved human review. External owner accounts cannot be substituted with invented values.
