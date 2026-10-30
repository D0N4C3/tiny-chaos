"""Safely initialize a LOCAL git repo and first scaffold commit.
Run from Godot root: python tools/bootstrap_repo.py
Does not set identity, configure a remote, or push.
"""
from pathlib import Path
import subprocess, sys
ROOT=Path(__file__).resolve().parents[1]

def git(*args, check=True):
    return subprocess.run(['git',*args],cwd=ROOT, capture_output=True,text=True,check=check)

def stop(message):
    raise SystemExit('STOP: '+message)

if not (ROOT/'project.godot').exists() or not (ROOT/'AGENTS.md').exists():
    stop('Run from the Tiny Chaos repository containing project.godot and AGENTS.md.')
try:
    rev=git('rev-parse','--show-toplevel',check=False)
except FileNotFoundError:
    stop('Git is not installed; install Git before starting feature work.')
if rev.returncode==0:
    if Path(rev.stdout.strip()).resolve()!=ROOT:
        stop('Directory is within a different parent Git repo. Choose a standalone destination.')
    print('Existing local Git repository:', ROOT)
else:
    create=git('init','-b','main',check=False)
    if create.returncode:
        stop('git init failed: '+create.stderr.strip())
    print('Initialized local Git on main:', ROOT)
# Run instruction lint before initial commit.
check=subprocess.run([sys.executable,str(ROOT/'tools/validate_agent_guidance.py')],cwd=ROOT)
if check.returncode: stop('Instruction/layout verification failed.')
exists=git('rev-parse','--verify','HEAD',check=False)
if exists.returncode==0:
    print('Repo already has a commit. No automatic staging or commit performed.')
    print(git('log','-1','--oneline').stdout.strip())
    sys.exit(0)
# Require an existing personal identity. Do not silently invent a user.
for key in ('user.name','user.email'):
    val=git('config','--get',key,check=False)
    if val.returncode or not val.stdout.strip():
        print(f'Local Git initialized. Set your own {key} and rerun this script.')
        sys.exit(2)
# Only stage initial, known starter paths. No -A / wild staging.
paths=['AGENTS.md','CLAUDE.md','README.md','project.godot','.gitignore','.gitattributes','.editorconfig',
       'addons','core','features','ui','content','assets','art_source','tests','tools','docs']
run=git('add','--',*paths,check=False)
if run.returncode: stop('Staging error: '+run.stderr.strip())
files=git('diff','--cached','--name-only').stdout.splitlines()
for f in files:
    if f.lower().endswith(('.keystore','.jks','.p12','.pem','.key')) or '/.env' in '/'+f or 'credentials' in f.lower():
        stop('Secret-like file staged: '+f+'; unstage it before continuing.')
if git('diff','--cached','--check',check=False).returncode:
    stop('Staged whitespace checks failed; fix before committing.')
print(f'Staged {len(files)} scaffold/specification files.')
ret=git('commit','-m','chore: bootstrap Tiny Chaos Godot repository',check=False)
if ret.returncode: stop('Initial commit failed: '+ret.stderr.strip())
print(ret.stdout.strip())
print('Local Git is ready. No remote configured or pushed.')
