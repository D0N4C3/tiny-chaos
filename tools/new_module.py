"""Create a project-owned folder and concise agent instruction pair.
Usage: python tools/new_module.py features/my_feature [--purpose "Feature description"]
"""
from pathlib import Path
import argparse, sys, re

ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('folder', help='Path relative to repository root')
p.add_argument('--purpose', default='Describe the responsibility and boundaries of this folder.')
a=p.parse_args()
rel=Path(a.folder)
if rel.is_absolute() or '..' in rel.parts or not rel.parts:
    raise SystemExit('ERROR: Provide a safe repository-relative path.')
if rel.parts[0] in ('.git','.godot','build','dist'):
    raise SystemExit('ERROR: Generated/VCS folders are not project-owned modules.')
if any(not re.fullmatch(r'[a-z][a-z0-9_]*|world_[0-9]{2}|[0-9]{2}_[A-Z]+',part) for part in rel.parts):
    raise SystemExit('ERROR: Use snake_case folder names (exceptions only for existing spec directories).')
tgt=(ROOT/rel).resolve()
if not tgt.is_relative_to(ROOT):
    raise SystemExit('ERROR: Path escapes repo root.')
if rel.parts[0]=='addons' and len(rel.parts)>1:
    raise SystemExit('ERROR: Do not inject agent files into vendor managed addons.')
if tgt.exists() and (tgt/'AGENTS.md').exists() and (tgt/'CLAUDE.md').exists():
    print('Already configured:',rel)
    sys.exit(0)
missing=[]
ancestors=[]
node=tgt
while node!=ROOT:
    if not node.is_relative_to(ROOT):
        raise SystemExit('ERROR: Path escapes repo root.')
    ancestors.append(node)
    node=node.parent
for node in reversed(ancestors):
    node.mkdir(parents=True,exist_ok=True)
    agent=node/'AGENTS.md'; claude=node/'CLAUDE.md'
    if not agent.exists():
        role=a.purpose if node==tgt else 'Organize owned modules in this subtree; keep scope clear.'
        agent.write_text(f'# {node.relative_to(ROOT).as_posix()}\n\nOwnership: {role}\n\nFollow root `AGENTS.md` for commits/tests. Read only task-relevant specs.\n',encoding='utf-8')
    if not claude.exists(): claude.write_text('@AGENTS.md\n',encoding='utf-8')
print('Initialized instructions:', tgt.relative_to(ROOT))
