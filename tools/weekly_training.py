#!/usr/bin/env python3
"""Build weekly-training.html from the 2026 Tracker (xlsx), the lifting Google Doc text, and the
rowing weekly CSV. Deterministic: no network access. See jobs/weekly-training.md.

Usage:
  python3 tools/weekly_training.py --xlsx tracker.xlsx --doc doc.txt --rowing jobs/data/rowing-weekly.csv \
      --template tools/weekly_training_template.html --out weekly-training.html \
      --build-id 2026-11-23T071500Z --today 2026-11-23
  Add --dump-weekly weekly.csv to also write the computed weekly table (used for regression checks).
"""
import argparse, collections, csv, datetime as dt, json, re, sys

MONTHS = ['January','February','March','April','May','June','July','August','September','October','November','December']
FIRST_WEEK = dt.date(2025, 12, 29)   # Monday of the week containing 2026-01-01
YEAR0 = 2026
MI = 0.000621371

# ---------------------------------------------------------------- lifting doc
def load_doc_text(path):
    raw = open(path, encoding='utf-8').read()
    try:
        j = json.loads(raw)
        if isinstance(j, dict) and 'fileContent' in j:
            return j['fileContent']
    except Exception:
        pass
    return raw

def split_sections(text):
    lines = [l.strip() for l in text.split('\n') if l.strip()]
    pat = re.compile(r'(?i)^#+\s*\**\s*(\d{1,2})/(\d{1,2})(/(\d{4}))?')
    pat2 = re.compile(r'(?i)^#+\s*\**\s*(sun|mon|tues|wednes|thurs|fri|satur)day\s+(\d{1,2})/(\d{1,2})')
    secs = []; cur = None
    for l in lines:
        m = pat2.match(l); mo = d = yr = None
        if m and len(l) < 120:
            mo, d = int(m.group(2)), int(m.group(3))
        else:
            m = pat.match(l)
            if m and len(l) < 120:
                mo, d = int(m.group(1)), int(m.group(2)); yr = int(m.group(4)) if m.group(4) else None
        if mo:
            cur = {'m': mo, 'd': d, 'y': yr, 'lines': []}; secs.append(cur)
        elif cur:
            cur['lines'].append(l)
    # The doc is newest-first. Walk oldest-first and roll the year forward when the month wraps.
    year = YEAR0; prev = None
    for s in reversed(secs):
        if s['y']:
            year = s['y']
        elif prev is not None and s['m'] < prev - 6:
            year += 1
        s['y'] = year; prev = s['m']
    out = []
    for s in secs:
        try:
            out.append((dt.date(s['y'], s['m'], s['d']), s['lines']))
        except ValueError:
            pass
    return out

# bench / squat / deadlift ---------------------------------------------------
_BAD = re.compile(r'(?i)bw|bodyweight|bulgarian|goblet|\bdb\b|dumbbell|rdl|romanian|suitcase|front|empty|incline|rear|thrust|warm|split|smith|should i|harder|heavy bench set')
_SET = re.compile(r'(?<![\d.])(\d{2,3}(?:\.\d)?)\s*[x×]\s*(\d{1,2})(?![\d]*\s*[x×])')
_SKIP = re.compile(r'(?i)^<!--|^\W*(last|your|target|since|so |note|goal)|rest|warm|^\W*bar\b|empty')
_CAPS = {'bench': 260, 'squat': 330, 'deadlift': 400}

def _kind(l):
    if _BAD.search(l) or re.match(r'(?i)^\W*(last|your|target|since|so )', l): return None
    low = l.lower()
    if 'bench' in low: return 'bench'
    if 'deadlift' in low: return 'deadlift'
    if 'squat' in low: return 'squat'
    return None

def barbell_lifts(sections):
    res = collections.defaultdict(lambda: collections.defaultdict(list))
    for d, lines in sections:
        cur = None
        for l in lines:
            k = _kind(l); has = bool(_SET.search(l))
            if k:
                cur = k
                if has and not re.search(r'\d\s*[x×]\s*\d+\s*[-–]\s*\d|^\W*\d\.\s.*—\s*\d[x×]\d', l):
                    for w, r in _SET.findall(l): res[d][k].append(float(w))
                continue
            if _SKIP.search(l) and not has: continue
            if has:
                if cur and not re.match(r'(?i)^\W*(last|your|target)', l):
                    for w, r in _SET.findall(l): res[d][cur].append(float(w))
                continue
            if re.match(r'^[\W\d]*[A-Za-z]', l) and len(l) < 80: cur = None
    out = {}
    for d, kinds in res.items():
        row = {}
        for k, cap in _CAPS.items():
            v = [w for w in kinds[k] if 95 <= w <= cap]
            row[k] = max(v) if v else None
        out[d] = row
    return out

# overhead press: barbell + Swiss bar + dumbbell (dumbbells counted as the pair) ----
_OH_NAME = re.compile(r'(?i)overhead press|\boh\b.*press|oh press|shoulder press|military press|swiss[- ]bar')
_OH_BAD = re.compile(r'(?i)goblet|smith|lateral|laterel|raise|fly|flys|curl|row|pull|hurt|superset|used swiss|lighter weight|warm')
_OH_SET = re.compile(r'(?<![\d.])(\d{2,3}(?:\.\d)?)\s*(?:lbs?\.?)?\s*(?:dbs?\.?)?\s*[x×]\s*(\d{1,2})(?!\d)')
_DB = re.compile(r'(?i)\bdbs?\b|dumbbell|neutral|per arm|/\s*arm|\barm\b')

def overhead_press(sections):
    out = {}
    for d, lines in sections:
        vals = []; cur = False; warm = False; hdb = False; swiss = False
        for l in lines:
            if re.match(r'(?i)^[#\W]*warm', l): warm = True; cur = False; continue
            if re.match(r'^[#\W]*\d+[A-Z]?\.\s', l) or (re.match(r'^#{2,3}\s', l) and not re.match(r'(?i)^#+\s*\**\s*warm', l)): warm = False
            if _OH_NAME.search(l) and not _OH_BAD.search(l) and not re.match(r'(?i)^\W*(last|your|target)', l):
                cur = True; hdb = bool(_DB.search(l)); swiss = bool(re.search(r'(?i)swiss', l))
                if not warm:
                    for w, r in _OH_SET.findall(l): vals.append(float(w) * (2 if hdb else 1))
                continue
            if cur and not warm and swiss and re.match(r'(?i)^\W*bar\s*[x×]\s*\d', l):
                vals.append(45.0); continue          # empty Swiss bar = 45 lb
            if cur and not warm and _OH_SET.search(l) and not re.match(r'(?i)^\W*(last|your|target)', l):
                if re.search(r'(?i)lateral|raise|fly|curl|row|pull|press|bench|squat|deadlift', l) and not _OH_NAME.search(l):
                    cur = False; continue
                ldb = hdb or bool(_DB.search(l))
                for w, r in _OH_SET.findall(l): vals.append(float(w) * (2 if ldb else 1))
                continue
            if cur and re.match(r'^[\W\d]*[A-Za-z]', l) and not re.match(r'(?i)^[\W\d]*(rest|bar\b|used)', l) and len(l) < 90 and not _OH_SET.search(l):
                cur = False
        v = [w for w in vals if 20 <= w <= 140]
        if v: out[d] = max(v)
    return out

# ---------------------------------------------------------------- running + rowing
def monday(d): return d - dt.timedelta(days=d.weekday())

def running_by_week(xlsx):
    import openpyxl
    wb = openpyxl.load_workbook(xlsx, data_only=True)
    mon = {m: i for i, m in enumerate(MONTHS, 1)}
    run = collections.defaultdict(lambda: [0, 0.0, 0.0])
    for r in wb['Workout Log'].iter_rows(values_only=True):
        if len(r) > 7 and r[1] in mon and isinstance(r[6], (int, float)) and r[6] > 0:
            try: y = int(r[3]) if isinstance(r[3], (int, float)) else YEAR0
            except Exception: y = YEAR0
            d = dt.date(y, mon[r[1]], int(r[2])); w = monday(d)
            run[w][0] += 1; run[w][1] += r[6]; run[w][2] += (r[7] or 0)
    return run

def rowing_by_week(path):
    rows = {}; as_of = None
    for line in open(path, encoding='utf-8'):
        if line.startswith('#'):
            m = re.search(r'as_of:\s*(\d{4}-\d{2}-\d{2})', line)
            if m: as_of = m.group(1)
    data = [l for l in open(path, encoding='utf-8') if not l.startswith('#')]
    for r in csv.DictReader(data):
        rows[r['week_start']] = (float(r['meters']), float(r['minutes']))
    return rows, as_of

# ---------------------------------------------------------------- assemble
def build(args):
    today = dt.date.fromisoformat(args.today)
    run = running_by_week(args.xlsx)
    row, row_asof = rowing_by_week(args.rowing)
    secs = split_sections(load_doc_text(args.doc))
    bb = barbell_lifts(secs); oh = overhead_press(secs)
    lift = collections.defaultdict(dict)
    for d, v in bb.items():
        w = monday(d)
        for k, x in v.items():
            if x: lift[w][k] = max(lift[w].get(k, 0), x)
    for d, x in oh.items():
        w = monday(d); lift[w]['ohp'] = max(lift[w].get('ohp', 0), x)
    weeks = []; w = FIRST_WEEK; last = monday(today)
    while w <= last:
        r = run.get(w, [0, 0.0, 0.0]); rm, rt = row.get(w.isoformat(), (0.0, 0.0)); l = lift.get(w, {})
        weeks.append({'w': w.isoformat(), 'runs': r[0], 'rm': round(r[1], 2), 'rt': round(r[2], 1),
                      'wm': round(rm * MI, 2), 'wt': round(rt, 1),
                      'bench': l.get('bench'), 'squat': l.get('squat'), 'dead': l.get('deadlift'), 'ohp': l.get('ohp')})
        w += dt.timedelta(days=7)
    return weeks, row_asof, today

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--xlsx', required=True); ap.add_argument('--doc', required=True)
    ap.add_argument('--rowing', required=True); ap.add_argument('--template', required=True)
    ap.add_argument('--out', required=True); ap.add_argument('--build-id', required=True)
    ap.add_argument('--today', required=True); ap.add_argument('--dump-weekly')
    a = ap.parse_args()
    weeks, row_asof, today = build(a)
    if a.dump_weekly:
        with open(a.dump_weekly, 'w', newline='') as f:
            wr = csv.writer(f); wr.writerow(list(weeks[0].keys()))
            for x in weeks: wr.writerow(['' if v is None else v for v in x.values()])
    meta = {'today': today.isoformat(), 'rowing_as_of': row_asof}
    html = open(a.template, encoding='utf-8').read()
    html = html.replace('__BUILD_ID__', a.build_id).replace('__DATA_JSON__', json.dumps(weeks)).replace('__META_JSON__', json.dumps(meta))
    open(a.out, 'w', encoding='utf-8').write(html)
    print('weeks=%d runs_total=%d rowing_as_of=%s -> %s' % (len(weeks), sum(x['runs'] for x in weeks), row_asof, a.out))

if __name__ == '__main__':
    main()
