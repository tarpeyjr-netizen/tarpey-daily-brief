#!/usr/bin/env bash
# Adds the Friday page specs and rosters to jobs/.
# jobs/training.md is shared with the Monday routine and needs the Drive connector.
# Run from the repo root, then commit and push to main.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/stocks.md <<'MARK_jobs_stocks_md'
# stocks.html — Weekly Stock Report

Cadence: Fridays. History: rolling 8-day window (today + prior editions 1–7 days old), so the
page shows the two most recent weekly editions.
Roster: jobs/rosters/stocks.csv (ticker,company,notes)

## Gate
None. Runs every Friday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run searches in parallel
batches. Headlines are one line, 140 characters max. No long quotes, no article scraping.

## 1 — Tickers
Read jobs/rosters/stocks.csv from the clone and cover every ticker. The notes column carries
special handling: BTC is spot USD; SPCX also gets its own News section. No fallback list and no
warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Data to gather, in parallel batches
1. 3–5 USA economic headlines from the past 7 days.
2. 3–5 global economic headlines from the past 7 days.
3. Per ticker: current price; 1W, 1M and 1Y return %; 1–2 headlines from the past 7 days;
   a Buy/Sell/Hold call with a one-sentence rationale.
   BTC is spot USD. Where an exact 1Y return is unavailable, estimate against the price about
   52 weeks ago and prefix the figure with "≈".
4. SpaceX: 1–3 notable headlines from the past 7 days.
5. One additional stock idea outside the list: name, ticker, two-sentence thesis.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.
Positive percentages go in <span class="pos">, negative in <span class="neg">. Recommendation
pills use b-buy / b-sell / b-hold. Prefix approximate figures with "≈".

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Weekly Stock Report — The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --green:#0a7d2c; --red:#c0271a; --gray:#888; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  .back:hover { color:#fff; }
  header h1 { font-size:25px; font-weight:700; letter-spacing:-0.3px; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:32px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:20px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .tablescroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:13.5px; border:1px solid #cccccc; }
  thead th { background:var(--navy); color:#fff; font-weight:bold; padding:10px 12px; border:1px solid #cccccc; text-align:center; }
  thead th.l { text-align:left; }
  tbody td { padding:8px 12px; border:1px solid #e0e0e0; }
  tbody tr:nth-child(odd) { background:#fff; }
  tbody tr:nth-child(even) { background:#f4f6fa; }
  td.tk { font-weight:bold; }
  td.num { text-align:right; }
  td.ctr { text-align:center; }
  .pos { color:var(--green); font-weight:600; }
  .neg { color:var(--red); font-weight:600; }
  .pill { display:inline-block; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold; color:#fff; }
  .b-buy { background:var(--green); } .b-sell { background:var(--red); } .b-hold { background:var(--gray); }
  .note { font-size:12px; color:var(--muted); margin-top:10px; }
  .stock { margin-bottom:16px; padding-bottom:14px; border-bottom:1px solid var(--line); }
  .stock:last-child { border-bottom:0; margin-bottom:0; padding-bottom:0; }
  .stock .hd { font-weight:700; font-size:14.5px; }
  .stock .rat { font-size:14px; margin:3px 0 5px; }
  .stock ul { margin-top:4px; }
  .stock li { font-size:13px; color:#444; }
  .disc { font-size:13px; color:var(--muted); font-style:italic; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header>
  <div class="wrap">
    <a class="back" href="index.html">&larr; Back to dashboard</a>
    <h1>Weekly Stock Report</h1>
    <div class="sub">Latest: week of [MON DATE] &ndash; [FRI DATE], [YYYY] &middot; showing the last 8 days</div>
  </div>
</header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Weekly Stock Report</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week of [MON DATE] &ndash; [FRI DATE], [YYYY] &middot; generated [GENERATED DATE]</div>
<section><h2>USA Economic Headlines</h2><ul>[3–5 <li>]</ul></section>
<section><h2>Global Economic Headlines</h2><ul>[3–5 <li>]</ul></section>
<section>
<h2>Portfolio Stock Performance</h2>
<div class="tablescroll"><table>
<thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Price</th><th>1W %</th><th>1M %</th><th>1Y %</th><th>Rec</th></tr></thead>
<tbody>[one tr per ticker: <td class="tk">TICKER</td><td>Company</td><td class="num">$Price</td><td class="num"><span class="pos|neg">±X%</span></td> ×3 <td class="ctr"><span class="pill b-buy|b-hold|b-sell">Buy|Hold|Sell</span></td>]</tbody>
</table></div>
<p class="note">≈ indicates an approximate or estimated figure where an exact period return was not available. Prices reflect the most recent close/quote. CGEMY ADR price estimated from the Euronext Paris listing.</p>
</section>
<section>
<h2>Stock Notes &amp; Headlines</h2>
[per ticker: <div class="stock"><div class="hd">TICKER &mdash; Company</div><div class="rat"><span class="pill b-buy|b-hold|b-sell">Buy|Hold|Sell</span> &nbsp;One-sentence rationale.</div><ul><li>headline</li></ul></div>]
</section>
<section><h2>SpaceX News</h2><ul>[1–3 <li>]</ul></section>
<section><h2>New Stock to Consider</h2><p style="font-size:14px;line-height:1.6;"><b>Name (TICKER)</b> &mdash; [two-sentence thesis]</p></section>
<section><p class="disc">This is not financial advice. Do your own research.</p></section>
</article>

## 5 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_stocks_md

cat > jobs/retirement.md <<'MARK_jobs_retirement_md'
# retirement.html — Retirement Destination Profile

Cadence: Fridays. History: today's edition + up to 5 prior (6 total).
Roster: jobs/rosters/retirement-destinations.csv (type,destination) — US rows first, then INTL.
CSV row ORDER within each type is the rotation order. Never re-sort it.

## Gate
None. Runs every Friday.

## 1 — Pick the destination
IMPORTANT — this job previously ran on SUNDAYS and its rotation was written around Sundays.
It now runs on FRIDAYS. The old algorithm, evaluated on a Friday, returned Asheville every
single US week and never advanced, because its loop walked Sundays and tested `d == today`,
which a Friday never satisfies. The corrected version below keys off the nth occurrence of the
run day in its month, which is weekday-agnostic. Do not reintroduce any Sunday logic.

International week = the SECOND Friday of the month. Every other Friday is a US week.

python3 - <<'PY'
import csv, datetime
rows=list(csv.DictReader(open('jobs/rosters/retirement-destinations.csv')))
US=[r['destination'] for r in rows if r['type']=='US']
INTL=[r['destination'] for r in rows if r['type']=='INTL']
today=datetime.date.today()
SEED=datetime.date(2026,7,21)          # Asheville seed, already published
nth=lambda d:(d.day-1)//7+1            # nth occurrence of this weekday in its month
is_intl = nth(today)==2
if is_intl:
    months=(today.year-2026)*12+(today.month-8)
    dest=INTL[months % len(INTL)]
else:
    f=SEED+datetime.timedelta(days=(4-SEED.weekday())%7)   # first Friday after the seed
    if f<=SEED: f+=datetime.timedelta(days=7)
    count, idx = 1, 0                   # start at 1 — index 0 (Asheville) was the seed
    while f<=today:
        if nth(f)!=2:
            if f==today: idx=count
            count+=1
        f+=datetime.timedelta(days=7)
    dest=US[idx % len(US)]
print(f"IS_INTL={is_intl}")
print(f"DESTINATION={dest}")
PY

Use the printed values for the rest of the run. When IS_INTL is true, note the country name
separately from the city/region.

The original prompt carried a guard for the seed date 2026-07-21. That date is in the past and
fell on a Tuesday, so a Friday routine can never hit it. No guard is needed.

## 2 — Research
WebSearch for accurate, current data. Never guess — if a figure cannot be found, write
"not readily available". 8–14 searches total, batching related topics.

1. Overall population — city and metro (or town and nearest major metro internationally)
2. Retirement-age population — % aged 65+, or the best retiree/expat proxy internationally
3. Climate — brief characterization
4. Distance to mountains — nearest range or hiking area, miles and drive time
5. Distance to beach/coast — nearest ocean or major lake beach, miles and drive time
6. Nearest airport — name/code, distance, roughly how many nonstops or notable direct routes;
   internationally, whether there is a direct or one-stop route back to the US
7. Walkability & transit — Walk Score if one exists (cite walkscore.com), noting any gap
   between citywide and downtown scores, plus a line on transit. Qualitative where no score
   exists.
8. Crime & safety — violent and property crime vs national average (NeighborhoodScout,
   AreaVibes, City-Data), with trend direction; Numbeo Safety Index internationally
9. Cost of living — index vs national average (or vs the home country internationally), a
   monthly figure if available, housing broken out
10. Taxes on retirement income — whether Social Security, pension and 401(k)/IRA withdrawals
    are taxed; state/local income tax rate; local property tax rate and any senior or homestead
    exemption. Internationally: residency and tax-treaty treatment of foreign retirement
    income, plus the local property tax equivalent
11. Housing — median home price / index vs national average, AND the recent price trend
    specifically for 2–3 bedroom homes, with a % if available. Cite Zillow, Redfin or local
    sources
12. Natural disaster risk & insurance — dominant risks, notable recent disaster history, and
    the state of the local home insurance market
13. Sports & leisure proximity — nearest pro franchises (or international equivalents: top-flight
    football, rugby, F1) and notable college athletics. Where pro sports are not a natural fit,
    note the nearest major sports or cultural hub rather than omitting the section
14. Senior services & community — number/range of 55+, independent living and CCRC options, a
    notable example, continuing-education programs, volunteer and civic opportunities.
    Internationally: expat community size, expat services, retiree visa or residency program
15. Healthcare — the leading local or regional hospital or health system and its rating
    (U.S. News, Healthgrades, CMS stars; internationally JCI accreditation, Numbeo Healthcare
    Index, or a recognized international ranking)

Prefer primary sources: Zillow, Redfin, US News, Healthgrades, Numbeo, NeighborhoodScout,
Walk Score, official city/county/state tax sites, World Population Review.

## 3 — Three photos
Wikimedia Commons hotlinks. Web page screenshots and WebFetch do not reliably return raw image
URLs, so use this exact recipe:

1. WebSearch `"File:" [destination] site:commons.wikimedia.org` and the same for a notable
   landmark or natural feature, to collect 3–5 candidate file titles.
2. Compute each direct hotlink — the upload path is the MD5 of the underscored title:

python3 - <<'PY'
import hashlib, urllib.parse
files=["Exact File Title One.jpg","Exact File Title Two.jpg","Exact File Title Three.jpg"]
for f in files:
    t=f.replace(" ","_"); h=hashlib.md5(t.encode()).hexdigest()
    print(f"https://upload.wikimedia.org/wikipedia/commons/{h[0]}/{h[0:2]}/{urllib.parse.quote(t)}")
PY

3. Verify each: curl -s -o /dev/null -w "%{http_code}" -L "URL" — keep only 200s. On a 404, try
   another candidate title.
4. Finish with exactly 3 verified URLs, each with a short caption and its
   https://commons.wikimedia.org/wiki/File:... page URL for attribution.
5. If Commons will not yield 3, fall back to direct hotlinkable .jpg/.png URLs from official
   tourism board or city government sites. Never use stock marketplaces (Getty, iStock,
   Shutterstock) — those do not hotlink.

## 4 — Page shell
Build stamp first line, above the doctype. Reuse the existing retirement.html <head> style
block verbatim from the clone — it already defines .photo-grid, .photo-grid img and
.photo-grid figcaption. Do not alter class names or the color scheme. Update the header .sub
date to today, then place today's article first followed by up to 5 prior articles.

## 5 — Today's edition block
The photo grid holds 3 images, the stat grid holds 8 items, and the 7 topic sections follow in
this exact order: Cost of Living, Taxes on Retirement Income, Housing Market, Natural Disaster
Risk & Insurance, Sports Proximity, Senior Services & Community, Healthcare & Hospitals.

<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head"><span class="tag[ intl]">[US Destination|International Destination]</span> [Weekday], [Month] [D], [YYYY]</div>
<section class="dest-card">
<h2 class="dest-name">[City/Town]</h2>
<div class="dest-region">[County/State or Region, Country] &middot; [short geographic descriptor]</div>
<div class="photo-grid">
  <figure><img src="[IMG1]" alt="[alt]" loading="lazy" onerror="this.style.display='none'"><figcaption>[caption] &middot; <a href="[COMMONS1]" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a></figcaption></figure>
  [two more figures]
</div>
<div class="stat-grid">
  <div class="stat-item"><span class="stat-label">Population</span><span class="stat-value">[figure]</span></div>
  <div class="stat-item"><span class="stat-label">65+ Population</span><span class="stat-value">[figure]</span></div>
  <div class="stat-item"><span class="stat-label">Climate</span><span class="stat-value">[short]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Mountains</span><span class="stat-value">[name &mdash; distance]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Beach</span><span class="stat-value">[name &mdash; distance]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Airport</span><span class="stat-value">[code &mdash; distance, routes]</span></div>
  <div class="stat-item"><span class="stat-label">Walk Score</span><span class="stat-value">[score]</span></div>
  <div class="stat-item"><span class="stat-label">Crime vs. National</span><span class="stat-value">[figure/trend]</span></div>
</div>
<h3 class="topic">Cost of Living</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Taxes on Retirement Income</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Housing Market</h3><p class="topic-summary">[3–5 sentences incl. the 2–3 bedroom trend, inline links]</p>
<h3 class="topic">Natural Disaster Risk &amp; Insurance</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Sports Proximity</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Senior Services &amp; Community</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Healthcare &amp; Hospitals</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
</section>
</article>

Use class "tag intl" (both classes) with the label "International Destination" when IS_INTL is
true; otherwise class "tag" alone with "US Destination".

## 6 — Merge
Keep up to 5 prior editions. If the newest existing article already carries today's date,
replace it rather than prepending a duplicate.
MARK_jobs_retirement_md

cat > jobs/training.md <<'MARK_jobs_training_md'
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
MARK_jobs_training_md

cat > jobs/rosters/stocks.csv <<'MARK_jobs_rosters_stocks_csv'
ticker,company,notes
NUKZ,Range Nuclear Renaissance ETF,
ACHR,Archer Aviation,
AMZN,Amazon,
GEV,GE Vernova,
GOOG,Alphabet,
MSFT,Microsoft,
PLTR,Palantir,
NVDA,Nvidia,
TSLA,Tesla,
BA,Boeing,
CRM,Salesforce,
SAP,SAP SE ADR,
CGEMY,Capgemini ADR,
ORCL,Oracle,
TDG,TransDigm,
ULTY,YieldMax Ultra Option Income Strategy ETF,
GPTY,YieldMax AI & Tech Portfolio Option Income ETF,
INDY,iShares India 50 ETF,
BTC,Bitcoin,spot USD
BE,Bloom Energy,
SPCX,SpaceX,also gets a separate News section
MARK_jobs_rosters_stocks_csv

cat > jobs/rosters/retirement-destinations.csv <<'MARK_jobs_rosters_retirement_destinations_csv'
type,destination
US,"Asheville, North Carolina"
US,"Greenville, South Carolina"
US,"The Villages, Florida"
US,"Sarasota, Florida"
US,"Hilton Head Island, South Carolina"
US,"Boise, Idaho"
US,"Scottsdale, Arizona"
US,"Naples, Florida"
US,"Charleston, South Carolina"
US,"Santa Fe, New Mexico"
US,"Prescott, Arizona"
US,"Georgetown, Texas"
US,"Chattanooga, Tennessee"
US,"Wilmington, North Carolina"
US,"Fort Myers, Florida"
US,"Tucson, Arizona"
US,"Bend, Oregon"
US,"Coeur d'Alene, Idaho"
US,"Traverse City, Michigan"
US,"Williamsburg, Virginia"
INTL,"Galway, Ireland"
INTL,"Algarve (Lagos), Portugal"
INTL,"San Miguel de Allende, Mexico"
INTL,"Cuenca, Ecuador"
INTL,"Boquete, Panama"
INTL,"Valencia, Spain"
INTL,"Chiang Mai, Thailand"
INTL,"Medellin, Colombia"
INTL,"Ambergris Caye, Belize"
INTL,"Dordogne, France"
INTL,"Sliema/Valletta, Malta"
INTL,"Punta del Este, Uruguay"
MARK_jobs_rosters_retirement_destinations_csv

echo "Created:"
ls -1 jobs/stocks.md jobs/retirement.md jobs/training.md jobs/rosters/stocks.csv jobs/rosters/retirement-destinations.csv
