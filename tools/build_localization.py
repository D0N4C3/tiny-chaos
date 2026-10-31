"""Build content/localization/strings.csv (Godot CSV translation) from the spec source table.
Source of truth: docs/spec/04_CONTENT/localization/LOCALIZATION_SOURCE_AND_TRANSLATION_TASKS.csv
Run: python tools/build_localization.py [--check]
Fails on duplicate/invalid keys, empty English text, or translations whose {placeholders}
differ from English. Empty translations are left empty so Godot falls back to English.
"""
from pathlib import Path
import argparse, csv, io, re, sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'docs/spec/04_CONTENT/localization/LOCALIZATION_SOURCE_AND_TRANSLATION_TASKS.csv'
TARGET = ROOT / 'content/localization/strings.csv'
LOCALES = ['en', 'es', 'pt_BR', 'fr', 'it']
# First segment lowercase namespace; later segments may hold stable IDs such as W01_L001.
KEY_RE = re.compile(r'^[a-z0-9_]+(\.[A-Za-z0-9_]+)+$')
PLACEHOLDER_RE = re.compile(r'\{[a-z0-9_]+\}')

def build():
    rows = list(csv.DictReader(SOURCE.open(encoding='utf-8-sig', newline='')))
    errors, seen, coverage = [], set(), {loc: 0 for loc in LOCALES}
    for row in rows:
        key = row['key'].strip()
        if not KEY_RE.match(key):
            errors.append(f'invalid key {key!r}')
        if key in seen:
            errors.append(f'duplicate key {key}')
        seen.add(key)
        english = row['en'].strip()
        if not english:
            errors.append(f'{key}: empty English source')
        expected = sorted(PLACEHOLDER_RE.findall(english))
        for loc in LOCALES:
            text = row.get(loc, '').strip()
            if text:
                coverage[loc] += 1
                if sorted(PLACEHOLDER_RE.findall(text)) != expected:
                    errors.append(f'{key}[{loc}]: placeholders {PLACEHOLDER_RE.findall(text)} != {expected}')
    buf = io.StringIO(newline='')
    writer = csv.writer(buf, lineterminator='\n')
    writer.writerow(['keys', *LOCALES])
    for row in rows:
        writer.writerow([row['key'].strip(), *[row.get(loc, '').strip() for loc in LOCALES]])
    return buf.getvalue(), errors, coverage, len(rows)

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='fail if strings.csv is stale or invalid')
    args = parser.parse_args()
    text, errors, coverage, total = build()
    for err in errors[:25]:
        print('ERROR:', err)
    if len(errors) > 25:
        print(f'... {len(errors) - 25} more errors')
    print('coverage: ' + ', '.join(f'{loc} {n}/{total}' for loc, n in coverage.items()))
    if errors:
        return 1
    if args.check:
        current = TARGET.read_text(encoding='utf-8') if TARGET.exists() else ''
        if current != text:
            print(f'{TARGET.relative_to(ROOT)} is stale; run python tools/build_localization.py')
            return 1
        print('strings.csv up to date')
        return 0
    TARGET.write_text(text, encoding='utf-8', newline='')
    print(f'wrote {TARGET.relative_to(ROOT)} ({total} keys)')
    return 0

if __name__ == '__main__':
    sys.exit(main())
