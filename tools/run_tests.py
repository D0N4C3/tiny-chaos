"""Run the headless GDScript test suite (tests/run_tests.gd) and return its exit code.
Run: python tools/run_tests.py [--godot PATH] [--filter SUBSTRING]   (or set GODOT_BIN)
Imports the project first so class_name caches exist on a fresh clone.
"""
from pathlib import Path
import argparse, os, subprocess, sys

ROOT = Path(__file__).resolve().parents[1]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--godot', default=os.environ.get('GODOT_BIN', ''), help='Godot 4.7.2 console executable')
    parser.add_argument('--filter', default='', help='only tests whose path or name contains this')
    parser.add_argument('--skip-import', action='store_true', help='skip the --import pass')
    args = parser.parse_args()
    if not args.godot:
        raise SystemExit('Set GODOT_BIN or pass --godot (use the *_console.exe build on Windows).')
    base = [args.godot, '--headless', '--path', str(ROOT)]
    if not args.skip_import:
        subprocess.run(base + ['--import'], capture_output=True, text=True, timeout=600)
    cmd = base + ['-s', 'res://tests/run_tests.gd', '--', '--test-run']
    if args.filter:
        cmd.append(f'--filter={args.filter}')
    return subprocess.run(cmd, timeout=900).returncode

if __name__ == '__main__':
    sys.exit(main())
