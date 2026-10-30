"""Report whether this machine has the pinned toolchain for Tiny Chaos Android builds.
Run: python tools/check_toolchain.py [--godot PATH]   (or set GODOT_BIN)
Read-only: prints PASS/FAIL per check and exits 1 if any required check fails.
"""
from pathlib import Path
import argparse, os, re, shutil, subprocess, sys

GODOT_VERSION = '4.7.2.stable'
JDK_MAJOR = 17
TARGET_SDK = 36
ANDROID_TEMPLATES = ('android_debug.apk', 'android_release.apk', 'android_source.zip')

results = []

def check(name, ok, detail, required=True):
    results.append((name, ok, required))
    tag = 'PASS' if ok else ('FAIL' if required else 'WARN')
    print(f'[{tag}] {name}: {detail}')

def run(*cmd):
    try:
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        return (out.stdout + out.stderr).strip()
    except (OSError, subprocess.TimeoutExpired) as exc:
        return f'error: {exc}'

def templates_dir():
    if sys.platform == 'win32':
        base = Path(os.environ.get('APPDATA', '')) / 'Godot'
    elif sys.platform == 'darwin':
        base = Path.home() / 'Library/Application Support/Godot'
    else:
        base = Path(os.environ.get('XDG_DATA_HOME', Path.home() / '.local/share')) / 'godot'
    return base / 'export_templates' / GODOT_VERSION

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--godot', default=os.environ.get('GODOT_BIN', ''), help='Godot editor executable')
    args = parser.parse_args()

    if args.godot:
        version = run(args.godot, '--version').splitlines()[-1:] or ['']
        check('Godot editor', version[0].startswith(GODOT_VERSION), version[0] or 'no output')
    else:
        check('Godot editor', False, 'pass --godot or set GODOT_BIN')

    tdir = templates_dir()
    missing = [t for t in ANDROID_TEMPLATES if not (tdir / t).is_file()]
    check('Export templates', not missing, f'{tdir} missing {missing}' if missing else str(tdir))

    sdk = Path(os.environ.get('ANDROID_HOME') or os.environ.get('ANDROID_SDK_ROOT') or '')
    check('Android SDK', sdk.is_dir() and str(sdk) != '.', str(sdk) or 'ANDROID_HOME not set')
    platforms = []
    if (sdk / 'platforms').is_dir():
        for p in (sdk / 'platforms').iterdir():
            m = re.match(r'android-(\d+)', p.name)
            if m: platforms.append(int(m.group(1)))
    check(f'SDK platform >= {TARGET_SDK}', any(p >= TARGET_SDK for p in platforms), f'found {sorted(platforms)}')
    build_tools = sorted(p.name for p in (sdk / 'build-tools').iterdir()) if (sdk / 'build-tools').is_dir() else []
    check('Build tools', bool(build_tools), ', '.join(build_tools) or 'none')

    java_text = run('java', '-version')
    m = re.search(r'version "(\d+)', java_text)
    major = int(m.group(1)) if m else 0
    check(f'JDK >= {JDK_MAJOR} on PATH', major >= JDK_MAJOR, java_text.splitlines()[0] if java_text else 'java not found')

    adb = shutil.which('adb') or str(sdk / 'platform-tools' / ('adb.exe' if sys.platform == 'win32' else 'adb'))
    devices = [l for l in run(adb, 'devices').splitlines()[1:] if l.strip().endswith('device')]
    check('Android device/emulator attached', bool(devices), f'{len(devices)} attached', required=False)

    failed = [n for n, ok, req in results if req and not ok]
    print(f'\n{len(results) - len(failed)}/{len(results)} checks passed' + (f'; failing: {failed}' if failed else ''))
    return 1 if failed else 0

if __name__ == '__main__':
    sys.exit(main())
