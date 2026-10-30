"""Update or list rows of docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv without reformatting it.
Run: python tools/tracker.py show P00                     (rows whose task_id starts with P00)
     python tools/tracker.py set P00-002 --status DONE --notes "..." --evidence "..." --verified-by AI_AGENT
Statuses: NOT_STARTED, IN_PROGRESS, DONE, BLOCKED. Writing DONE requires --evidence (or existing evidence).
"""
from pathlib import Path
import argparse, csv, datetime, io, sys

TRACKER = Path(__file__).resolve().parents[1] / 'docs/spec/05_EXECUTION/IMPLEMENTATION_TRACKER.csv'
STATUSES = ('NOT_STARTED', 'IN_PROGRESS', 'DONE', 'BLOCKED')
FIELDS = {'status': 'status', 'notes': 'implementation_notes', 'evidence': 'commit_or_evidence',
          'blocked_by': 'blocked_by', 'verified_by': 'verified_by'}

def load():
    text = TRACKER.read_text(encoding='utf-8-sig')
    newline = '\r\n' if '\r\n' in text else '\n'
    rows = list(csv.DictReader(io.StringIO(text, newline='')))
    return rows, newline

def save(rows, newline):
    buf = io.StringIO(newline='')
    writer = csv.DictWriter(buf, fieldnames=list(rows[0].keys()), lineterminator=newline)
    writer.writeheader(); writer.writerows(rows)
    TRACKER.write_text(buf.getvalue(), encoding='utf-8-sig', newline='')

def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest='cmd', required=True)
    show = sub.add_parser('show'); show.add_argument('prefix')
    upd = sub.add_parser('set'); upd.add_argument('task_ids', nargs='+')
    upd.add_argument('--status', choices=STATUSES)
    for flag in ('notes', 'evidence', 'blocked_by', 'verified_by'):
        upd.add_argument('--' + flag.replace('_', '-'), dest=flag)
    args = parser.parse_args()

    rows, newline = load()
    if args.cmd == 'show':
        for r in rows:
            if r['task_id'].startswith(args.prefix):
                print(f"{r['task_id']} [{r['status']}] {r['task']} | {r['commit_or_evidence']} | {r['blocked_by']}")
        return 0
    by_id = {r['task_id']: r for r in rows}
    unknown = [t for t in args.task_ids if t not in by_id]
    if unknown: raise SystemExit(f'Unknown task id(s): {unknown}')
    for tid in args.task_ids:
        row = by_id[tid]
        for arg, col in FIELDS.items():
            value = getattr(args, arg)
            if value is not None: row[col] = value
        if row['status'] == 'DONE':
            if not row['commit_or_evidence'].strip():
                raise SystemExit(f'{tid}: DONE requires --evidence')
            row['verified_date'] = row['verified_date'] or datetime.date.today().isoformat()
        print(f"{tid} -> {row['status']}")
    save(rows, newline)
    return 0

if __name__ == '__main__':
    sys.exit(main())
