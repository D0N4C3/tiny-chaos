# Daily Circuit, Weekly Lab and Beat My Rescue

## Full-release feature scope

- All 90 planned daily variants (30 UTC days × three slots) are authored and **QA-cleared** before release. They may reuse campaign layouts but must have tested, specific new conditions and valid solution traces.
- All 12 weekly event episodes (three stages per episode = 36 individual validated challenges) are built before release. Content can rotate over twelve weeks without network; feature updates later add new content.
- Every shared challenge is a curated puzzle from shipped content; user-authored levels and free-text sharing are **not** in launch scope (to avoid moderation costs and safety risk).

## Daily Circuit

- A fixed daily cycle origin configured in release settings; one global UTC day at a time; every player gets the same three approved challenge IDs and constraints.
- Slots: Quick Fix / Perfect Timing / Master Inventor.
- Player can play offline; local completion stored using schedule date plus challenge ID. Duplicate reward defense is key-based.
- Archive displays past cycles; no hard login streak or lost rewards from missing a day; repeat passes do not mint unlimited currency.
- If clock is inaccurate offline, allow local play but do not assert competitive ranking in any future shared score service.
- Content update pipeline checks schedule only references `RELEASE_APPROVED` puzzle variants; fallback to approved static daily if otherwise broken.

## Weekly Lab

- Each episode has story premise, three levels, three funny outcome moments and one cosmetic invention.
- Episodes must be completable individually. The archive stays playable; achievement trophies can record original event week without locking gameplay.
- Don't falsely present server-synchronized leaderboards with local-only data.

## Beat My Rescue (curated puzzle challenge system)

### User flow

Player wins a level → Share → game renders share card from **actual current scene** showing Pip and a meaningful moment → Android share sheet sends card with versioned challenge code + short CTA → recipient installs/opens app → challenge importer resolves original curated puzzle ID → plays same puzzle → sees local comparison against sender's recorded action count.

### Security and versioning

- Challenge code carries `format_version`, `puzzle_asset_id`, `ruleset_hash`, `score_bucket`/action count and checksum for accidental corruption; reject unknown IDs and malformed parameters. Sender-reported scores are untrusted without server verification; never present them as anti-cheat verified. Do not carry personally identifying info.
- Verified web links require owner-supplied domain, App Links relationship and safe fallback to store page. Never invent a domain, even for tests. Share text and numeric/short code works without network.
- Future optional leaderboards require an authoritative backend and anti-cheat; no such system is specified for launch.

### Engagement measurement

Measure `challenge_share`, Android share sheet completion when observable, `challenge_import`, `challenge_start`, `challenge_finish`, and attributable install if referral infrastructure legitimately supports it. Social shares and viral videos are not the same as installs or retained users.

## Viral creative principles

- Gameplay footage must show real, achievable puzzles, not fake physics or outcomes.
- In the first 2 seconds show a readable problem. At seconds 3–7 show one wrong or clever player action. End with a chain reaction and an actual result.
- Create three creative families: `Can you save Pip?`, `I fixed this with one piece`, `I found the impossible bonus route`.
- Export 9:16 at 1080×1920 from actual in-game camera or replay, with captions/safe margins. If Android video export is costly, first-party gameplay captured during tests can seed marketing, while in-app shares use PNG cards.
- Avoid false scarcity, deception or engineered near-win failures designed solely to force ads.
