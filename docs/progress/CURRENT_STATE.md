# Current project state ? keep under 80 lines

**Status:** Full-game repository scaffold; gameplay, completed levels, Android builds and runtime tests remain unimplemented. Localization source and locale fallback are in progress (P01-013).

**Last verified:** `python tools/validate_agent_guidance.py` passed (59 directories, 0 problems); `python tools/build_localization.py --check` passed (348 English keys, other locales empty); `git diff --check` passed. Godot runtime/export and Android UI verification have not run.

**Git:** Local Git is on `main`; localization WIP commit: `8281c61`. Remote publication is authorized for `https://github.com/D0N4C3/tiny-chaos.git`.

**Next:** Finish P01-013 with Godot locale and settings UI/runtime verification; then continue boot, Android export smoke test and data-driven level loader.

**Blockers:** Godot runtime is unavailable in the current shell. Owner-controlled package name, AdMob, billing and release credentials must not be guessed or committed.
