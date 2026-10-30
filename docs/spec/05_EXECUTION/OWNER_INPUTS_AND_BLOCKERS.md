# Owner actions and allowed AI fallbacks

The agent should build all code/content possible without pausing for these inputs, but must not pretend these externally owned services can be activated using invented information.

| Owner input | Required for | Safe agent fallback |
|---|---|---|
| Final app/company/brand name | Store publishing and trademark clearance | Use working title in game, postpone public naming clearance |
| Publisher package ID | Play/App Links/Billing | Temporary `com.yourstudio.tinychaos` development ID |
| Google Play Console access | Real release and test purchases | Export debug build; build billing adapter + mock; mark real purchase verification blocked |
| Android signing key / Play App Signing | Signed AAB, verified links | Export unsigned/test AAB; document secure setup |
| AdMob account and real IDs | Production ad serving | Use SDK test ad IDs and no-op editor adapters; never invent real IDs |
| UMP privacy/legal assessment | Global ad consent | Build privacy choices and SDK guard; default blocked until configured |
| Hosted privacy policy & support URL | Play listing compliance | Draft copy and placeholder URL, never claim published |
| Domain with HTTPS, verified signing cert | Friend App Links | Share code/PNG; implement intent handler and fallback docs |
| Native speaker review / localization approval | Full EN ES PTBR FR IT launch | Create editable translation CSV and UI fallback; mark locale QA blocked |
| Connected MCP tools | Direct editable 3D/Illustrator generation | Produce editable Blender script and SVG source, not random internet artwork |

All unresolved items must be listed with exact required owner action in every release handoff. Build as far as possible without requiring the user to repeat previously known decisions.
