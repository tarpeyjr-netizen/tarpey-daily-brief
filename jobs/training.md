# training.html — Training Dashboard

Cadence: Mondays AND Fridays. History: NONE — the dashboard is regenerated whole each run, no
<article class="edition"> blocks and no merge step.
Data source: the 2026 training log, a Google DOC read through the Drive connector.

This spec is read by both the Monday and the Friday routine. Same page, same file, both days.

## Gate
None. Runs every Monday and Friday.

## 1 — Read the log — THIS PAGE NEEDS THE GOOGLE DRIVE CONNECTOR
Read the training log with the Drive connector's read_file_content:

  fileId: 1kOu681X9cQD3vYJNJhWiYSriB22qlzVxGyMYNoW8t54

This is the ONLY page in the whole system that still needs a connector. It is a living document
Jim updates after each session, not a roster, so it cannot move into the repository the way the
CSV rosters did. The routine that runs this page must have Google Drive attached.

Parse every dated workout entry. If the Drive connector is unavailable, this is a FAILED page —
report it with the error. Do not publish a dashboard built from stale or invented data.

## 2 — Dates
python3 -c "
import datetime
t=datetime.date.today(); print('TODAY=',t); print('SIXTY=',t-datetime.timedelta(days=60))
"

## 3 — Per exercise, compute
- Last performed — most recent date it appears, and days since today
- Recent weight — the highest weight in that most recent session, with reps at that weight
- Peak set — the single highest weight ever recorded, with reps at that weight
- ~60 days ago — the weight in the session closest to the 60-day mark, with reps and date.
  If the closest session is more than 30 days from that mark, treat as no data ("—")
- % change — ((peak − 60d) / 60d) × 100, rounded to the nearest integer. "—" with no 60d data
- Status — Active (≤ 30 days ago) · Stalled (31–45) · Dormant (> 45)
- Frequency — sessions containing that exercise in the last 30 days, and in the last 60

Categorize each exercise:
- Upper — any press, row, pull, curl, pulldown, pullover, fly, raise, face pull, tricep, shoulder
- Lower — squat, deadlift, lunge, hinge, step up, hip thrust, leg curl, leg extension, leg press,
  split squat, calf raise

## 4 — Structure, three levels
1. Top-level sections: **Upper Body**, then **Lower Body**
2. Within each: **Active**, then **Stalled**, then **Dormant**. Omit a subsection entirely when
   it has no exercises for that body part
3. Within each subsection: sort by Recent Weight, descending

Then a summary bar at the bottom: overall Active/Stalled/Dormant counts, biggest % gains,
heaviest lift, most frequent exercise.

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Training Dashboard &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:1100px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 40px; }
  .section-header { display:flex; align-items:center; gap:10px; margin:36px 0 16px; padding-bottom:10px; border-bottom:2px solid var(--navy); }
  .section-header:first-of-type { margin-top:0; }
  .section-title { font-size:16px; font-weight:700; color:var(--navy); text-transform:uppercase; letter-spacing:.05em; }
  .section-count { font-size:12px; font-weight:600; padding:2px 10px; border-radius:99px; }
  .count-upper { background:#dbeafe; color:#1e40af; }
  .count-lower { background:#dcfce7; color:#166534; }
  .subsection-header { display:flex; align-items:center; gap:10px; margin:20px 0 10px; }
  .subsection-title { font-size:12.5px; font-weight:700; color:var(--ink); text-transform:uppercase; letter-spacing:.04em; }
  .subsection-count { font-size:11px; font-weight:600; padding:1px 9px; border-radius:99px; }
  .count-active { background:#dcfce7; color:#166534; }
  .count-stalled { background:#fef9c3; color:#854d0e; }
  .count-dormant { background:#fee2e2; color:#991b1b; }
  .tbl-wrap { background:#fff; border:1px solid var(--line); border-radius:12px; overflow:hidden; margin-bottom:20px; }
  table { width:100%; border-collapse:collapse; font-size:13.5px; }
  thead tr { background:#f0f4f9; }
  thead th { padding:10px 13px; text-align:left; font-size:11px; font-weight:700; color:var(--muted); text-transform:uppercase; letter-spacing:.07em; white-space:nowrap; }
  thead th.r { text-align:right; }
  tbody tr { border-top:1px solid var(--line); }
  tbody tr:hover { background:#f8fafc; }
  tbody td { padding:10px 13px; vertical-align:middle; }
  tbody td.r { text-align:right; }
  .ex-name { font-weight:600; color:var(--ink); }
  .ex-unit { display:block; font-size:11px; color:var(--muted); font-weight:400; margin-top:1px; }
  .ex-note { display:block; font-size:11px; color:#92400e; background:#fef3c7; border-radius:4px; padding:2px 6px; margin-top:4px; width:fit-content; }
  .days-ago { font-weight:600; color:var(--ink); }
  .days-date { display:block; font-size:11px; color:var(--muted); margin-top:1px; }
  .peak { font-weight:700; color:var(--navy); }
  .peak-reps { font-size:11px; color:var(--muted); margin-left:2px; }
  .sixty-w { font-weight:500; }
  .sixty-d { display:block; font-size:11px; color:var(--muted); margin-top:1px; }
  .chg-up { color:#16a34a; font-weight:700; }
  .chg-down { color:#dc2626; font-weight:700; }
  .chg-same { color:var(--muted); }
  .chg-na { color:#d1d5db; }
  .freq { font-variant-numeric:tabular-nums; }
  .freq-d { display:block; font-size:10px; color:var(--muted); margin-top:1px; }
  .summary { background:#fff; border:1px solid var(--line); border-radius:12px; padding:20px 24px; margin-top:32px; display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:16px; }
  .summary-title { grid-column:1/-1; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.07em; color:var(--muted); margin-bottom:4px; padding-bottom:10px; border-bottom:1px solid var(--line); }
  .stat-val { font-size:22px; font-weight:800; color:var(--navy); line-height:1.1; }
  .stat-lbl { font-size:11px; color:var(--muted); margin-top:3px; }
  .stat-sub { font-size:11px; color:var(--ink); margin-top:2px; font-weight:500; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
  @media(max-width:700px) { table { font-size:12px; } thead th, tbody td { padding:8px 8px; } }
</style>
</head>
<body>
<header><div class="wrap">
  <a class="back" href="/">&larr; Back to dashboard</a>
  <h1>Training Dashboard</h1>
  <div class="sub">Updated [DAY, MONTH D YYYY] &nbsp;&middot;&nbsp; Source: 2026 training log &nbsp;&middot;&nbsp; ~60 days ago = [60D DATE]</div>
</div></header>
<main class="wrap">
[UPPER BODY SECTION — section-header with count-upper, then Active / Stalled / Dormant subsections]
[LOWER BODY SECTION — same, count-lower]
[SUMMARY BAR — div.summary]
</main>
<footer>The Daily Brief &middot; Training Dashboard</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

Table columns, in order: Exercise | Last Performed | Recent Weight | Peak Set | ~60 Days Ago |
Change | Freq (30d / 60d)

Row shape:
<tr>
  <td><span class="ex-name">[Exercise]</span><span class="ex-unit">[e.g. "per dumbbell · lbs"]</span>[optional <span class="ex-note">ℹ️ caveat</span>]</td>
  <td class="r"><span class="days-ago">[N] days ago</span><span class="days-date">[Month D]</span></td>
  <td class="r"><span class="peak">[recent max] lbs</span><span class="peak-reps">× [reps]</span></td>
  <td class="r"><span class="peak">[all-time peak] lbs</span><span class="peak-reps">× [reps]</span></td>
  <td class="r"><span class="sixty-w">[weight] lbs × [reps]</span><span class="sixty-d">[Month D] or —</span></td>
  <td class="r [chg-up|chg-down|chg-same|chg-na]">[↑/↓/→] [N]% or —</td>
  <td class="r"><span class="freq">[30d] / [60d]</span><span class="freq-d">sessions</span></td>
</tr>
