"""Validate that project-owned folders have two small agent instruction files.
Run: python tools/validate_agent_guidance.py
"""
from pathlib import Path
import sys, re
ROOT=Path(__file__).resolve().parents[1]
EXCLUDE_DIRS={'.git','.godot','build','dist','.venv','venv','__pycache__','.cache','tmp','generated'}
errors=[]; count=0
for folder in ROOT.rglob('*'):
    if not folder.is_dir(): continue
    rel=folder.relative_to(ROOT)
    if any(p in EXCLUDE_DIRS for p in rel.parts): continue
    if folder.parts[-1] in {'.git','.godot'}: continue
    if 'addons' in rel.parts and rel.parts.index('addons')+1<len(rel.parts):
        continue # third-party contents managed upstream
    # Third-party vendor drops inside assets/ are exempt only if marked by a
    # parent third_party_manifest.json, else caller must add instructions.
    if any((p/'third_party_manifest.json').exists() for p in [folder,*folder.parents] if p!=ROOT):
        continue
    count+=1
    ag=folder/'AGENTS.md'; cl=folder/'CLAUDE.md'
    if not ag.is_file(): errors.append(f'Missing {ag.relative_to(ROOT)}')
    elif len(ag.read_text(encoding='utf-8').splitlines())>35:
        errors.append(f'Overlong (more than 35 lines): {ag.relative_to(ROOT)}')
    if not cl.is_file(): errors.append(f'Missing {cl.relative_to(ROOT)}')
    elif cl.read_text(encoding='utf-8').strip()!='@AGENTS.md':
        errors.append(f'CLAUDE.md must be only @AGENTS.md: {cl.relative_to(ROOT)}')
    elif cl.stat().st_size>100: errors.append(f'Overlong CLAUDE.md: {cl.relative_to(ROOT)}')
for f in ('AGENTS.md','CLAUDE.md','README.md','project.godot','.gitignore','docs/progress/CURRENT_STATE.md','docs/spec/07_REPO_GUIDE/CONTEXT_ROUTING.md'):
    if not (ROOT/f).exists(): errors.append(f'Missing root requirement: {f}')
if '@docs' in (ROOT/'CLAUDE.md').read_text(encoding='utf-8'):
    errors.append('Root CLAUDE.md imports a full spec: forbidden')
if not (ROOT/'docs/.gdignore').exists():errors.append('Missing docs/.gdignore')
if not (ROOT/'art_source/.gdignore').exists():errors.append('Missing art_source/.gdignore')
print(f'Checked {count} owned directories; {len(errors)} problem(s).')
for e in errors: print('ERROR:',e)
sys.exit(1 if errors else 0)
