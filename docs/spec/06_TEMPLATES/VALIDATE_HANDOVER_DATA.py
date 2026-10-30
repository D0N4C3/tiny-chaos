#!/usr/bin/env python3
"""Offline integrity audit for Tiny Chaos handover. No external dependencies required.
Usage: python 06_TEMPLATES/VALIDATE_HANDOVER_DATA.py
This validates source *documentation* only; it does NOT validate Godot runtime puzzles.
"""
from pathlib import Path
import csv
import json
import re
import sys

ROOT=Path(__file__).resolve().parents[1]
errors=[]

def check(condition,message):
    if not condition: errors.append(message)

def read_csv(path):
    with (ROOT/path).open('r',newline='',encoding='utf-8-sig') as handle:
        return list(csv.DictReader(handle))

campaign=read_csv('04_CONTENT/LEVEL_DESIGN_PLAN_120.csv')
daily=read_csv('04_CONTENT/DAILY_CHALLENGE_PLAN_90.csv')
weekly=read_csv('04_CONTENT/WEEKLY_EVENT_PLAN_12.csv')
weekly_missions=read_csv('04_CONTENT/WEEKLY_MISSION_DESIGN_PLAN_36.csv')
cosmetics=read_csv('04_CONTENT/COSMETIC_CATALOG.csv')
gadgets=read_csv('04_CONTENT/GADGET_CATALOG.csv')
assets=read_csv('03_ART/asset_sources.csv')
ledger=read_csv('03_ART/LICENSE_LEDGER.csv')
tracker=read_csv('05_EXECUTION/IMPLEMENTATION_TRACKER.csv')
qa=read_csv('05_EXECUTION/QA_TEST_CASES.csv')
analytics=read_csv('05_EXECUTION/ANALYTICS_EVENTS.csv')

for label,items,expected in [('campaign levels',campaign,120),('daily design briefs',daily,90),('weekly events',weekly,12),('weekly missions',weekly_missions,36),('cosmetics',cosmetics,48),('gadget types',gadgets,12),('implementation tasks',tracker,177),('QA cases',qa,129),('analytics events',analytics,51)]:
    check(len(items)==expected, f'{label}: {len(items)} != {expected}')

ids=[r['level_id'] for r in campaign]
check(len(ids)==len(set(ids)),'Duplicate main level IDs')
for wid in range(1,7):
    count=sum(r['world_id']==f'W{wid:02}' for r in campaign)
    check(count==20,f'World {wid} has {count} levels, expected 20')
check(len({r['daily_id'] for r in daily})==90,'Duplicate daily IDs')
check({r['based_on_level_id'] for r in daily} <=set(ids),'Daily bases missing from campaign')
for row in weekly:
    for k in ('mission_1_base','mission_2_base','mission_3_base'):
        check(row[k] in ids,f"Weekly event {row['event_id']} invalid base {row[k]}")
check(len({r['weekly_mission_id'] for r in weekly_missions})==36,'Duplicate weekly mission IDs')
check({r['based_on_main_level'] for r in weekly_missions} <=set(ids),'Weekly missions base ID invalid')
check(len({r['source_id'] for r in assets})==len(assets),'Duplicate asset source IDs')
check(len(assets)==len(ledger),'Asset/ledger source mismatch')
check(all(a['download_status']=='NOT_DOWNLOADED' for a in assets),'Wrong claim: assets downloaded')
check(len({r['task_id'] for r in tracker})==len(tracker),'Duplicate implementation IDs')
check(len({r['qa_id'] for r in qa})==len(qa),'Duplicate QA IDs')

schema=json.loads((ROOT/'04_CONTENT/level_schema.json').read_text(encoding='utf-8'))
required=set(schema['required'])
examples=list((ROOT/'04_CONTENT/example_levels').glob('*.json'))
check(len(examples)==12,'Exactly 12 design-only JSON examples expected')
for p in examples:
    obj=json.loads(p.read_text(encoding='utf-8'))
    missing=required-set(obj)
    check(not missing,f'{p.name}: missing {sorted(missing)}')
    check(obj['id'] in ids,f'{p.name}: level not in campaign manifest')
    check(obj['qa_status']=='DESIGN_ONLY_NOT_VERIFIED',f'{p.name}: misleading QA status')

try:
    import jsonschema
except ImportError:
    print('NOTICE: optional jsonschema package not installed; basic JSON checks only.')
else:
    validator=jsonschema.Draft202012Validator(schema)
    for p in examples:
        for err in validator.iter_errors(json.loads(p.read_text(encoding='utf-8'))):
            errors.append(f'{p.name} schema: {err.message}')

# No accidental inconsistent count/name phrases in core docs
for path in ROOT.rglob('*.md'):
    s=path.read_text(encoding='utf-8')
    check('DAILY_CHALLENGE_PLAN_60' not in s, f'{path.name}: stale daily manifest name')
    check('ASSET_RESEARCH_AND_SOURCES.md' not in s, f'{path.name}: stale asset docs name')

if errors:
    for e in errors: print('FAIL:',e)
    sys.exit(1)
print(f'PASS: {len(campaign)} main briefs, {len(daily)} daily briefs, {len(weekly)} weekly episodes, '
      f'{len(gadgets)} gadgets, {len(cosmetics)} cosmetics, {len(assets)} sources, '
      f'{len(tracker)} implementation tasks, {len(qa)} QA cases, {len(analytics)} analytics events, '
      f'{len(examples)} JSON examples.')
print('NOTE: No physics outcomes, license downloads, app builds, or Android SDK integrations are validated by this script.')
