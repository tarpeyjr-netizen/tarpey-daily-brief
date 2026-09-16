#!/usr/bin/env bash
# Adds the Monday-only page specs and roster to jobs/.
# jobs/sports.md (Thursday) and jobs/training.md (Friday) are already in the repo.
# Run from the repo root, then commit and push to main.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/stock-analysis.md <<'MARK_jobs_stock_analysis_md'
# stock-analysis.html — Stock Analysis

Cadence: Mondays. History: NONE — this is a snapshot page, fully replaced each run. No
<article class="edition"> blocks and no merge step. Roster: none.

Two sections: the Beat & Trim tracker, then Upcoming Earnings for the next 5 business days.

## Gate
None. Runs every Monday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run searches in parallel
batches. No article scraping beyond what is needed to confirm a figure.

## 1 — Beat & Trim, trailing 6 months
S&P 500 / large-cap US stocks that in the trailing 6 months (a rolling window, recomputed
fresh each run) reported quarterly earnings that BEAT analyst estimates on EPS and/or revenue
but SIMULTANEOUSLY cut, lowered or trimmed forward guidance.

Search with queries like "beat earnings lowered guidance", "beats estimates cuts outlook",
"earnings beat guidance cut", "trims full-year guidance", combined with "S&P 500" or
"large cap". Vary the queries across sources (Reuters, Bloomberg, CNBC, Barron's, Seeking
Alpha, Yahoo Finance, MarketWatch) and across months within the window.

BOTH conditions must be verified for every candidate:
(a) EPS or revenue beat consensus for that quarter, AND
(b) forward guidance — next quarter or full year — was lowered relative to prior guidance.

Exclude beat-only, cut-only, and ambiguous cases. Guidance merely reaffirmed or in-line is NOT
a trim. If sources conflict or both conditions cannot be confirmed cleanly, leave the stock
out rather than guess.

Per qualifying stock record: report date, the beat (metric and magnitude if available), the
guidance change (old vs new range if available).

Then three price points via WebSearch ("[ticker] stock 52 week high", "[ticker] stock price
[report date]", "[ticker] stock price today"):
- 52-week high, current
- Post-trim price — the close within 1–2 trading days after the guidance-cut report
- Current price — latest available quote

These are news-search-derived, not live quotes. The page says so in its note; keep that note.
Prefix approximate figures with "≈".

Sort by report date, most recent first. If nothing qualifies, still render the section with its
empty-state row rather than omitting it.

## 2 — Upcoming earnings, next 5 business days
S&P 500 / large-cap US stocks scheduled to report within the next 5 business days. Compute
today and skip weekends with `date +%F` and `date +%u`.

Search "earnings calendar this week S&P 500", "companies reporting earnings [date range]",
named large caps known to be in the current season, and finance-site earnings calendars
(Nasdaq, Yahoo Finance, Zacks, MarketBeat, TipRanks).

Per company record: ticker, company name, scheduled report date, before-market-open (BMO) or
after-market-close (AMC) timing when available, and the consensus EPS estimate when readily
available.

Sort by report date ascending, then alphabetically by ticker within a date. Aim for roughly
10–30 names depending on how busy the week is. Do not pad with small or mid caps. A quiet week
is fine — show what is there, or the empty-state row.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.
Inside <main class="wrap">: one <div class="asof"> with today's date, then Beat & Trim, then
Upcoming Earnings, then the disclaimer.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Stock Analysis — The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --green:#0a7d2c; --red:#c0271a; --gray:#888; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:1000px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  .back:hover { color:#fff; }
  header h1 { font-size:25px; font-weight:700; letter-spacing:-0.3px; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  .asof { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  .tablescroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:13px; border:1px solid #cccccc; }
  thead th { background:var(--navy); color:#fff; font-weight:bold; padding:10px 10px; border:1px solid #cccccc; text-align:center; }
  thead th.l { text-align:left; }
  tbody td { padding:8px 10px; border:1px solid #e0e0e0; vertical-align:top; }
  tbody tr:nth-child(odd) { background:#fff; }
  tbody tr:nth-child(even) { background:#f4f6fa; }
  td.tk { font-weight:bold; }
  td.num { text-align:right; white-space:nowrap; }
  td.ctr { text-align:center; }
  .pos { color:var(--green); font-weight:600; }
  .neg { color:var(--red); font-weight:600; }
  .note { font-size:12px; color:var(--muted); margin-top:10px; }
  .empty { font-size:14px; color:var(--muted); padding:10px 0; }
  .disc { font-size:13px; color:var(--muted); font-style:italic; }
  .tag-bmo { display:inline-block; padding:1px 6px; border-radius:8px; font-size:11px; font-weight:bold; background:#e0e7ef; color:var(--navy); }
  .tag-amc { display:inline-block; padding:1px 6px; border-radius:8px; font-size:11px; font-weight:bold; background:#1f3a5f; color:#fff; }
</style>
</head>
<body>
<header>
  <div class="wrap">
    <a class="back" href="index.html">&larr; Back to dashboard</a>
    <h1>Stock Analysis</h1>
    <div class="sub">Beat-and-trim tracker plus the week ahead's large-cap earnings calendar</div>
  </div>
</header>
<main class="wrap">
  <div class="asof">As of [TODAY LONG DATE]</div>
  <section>
    <h2>Beat &amp; Trim — Trailing 6 Months</h2>
    <div class="tablescroll"><table>
      <thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Report Date</th><th class="l">What Beat</th><th class="l">What Got Trimmed</th><th>52-Wk High</th><th>Post-Trim Price</th><th>Current Price</th></tr></thead>
      <tbody>[one tr per qualifying stock, most recent first, OR <tr><td colspan="8" class="empty">No qualifying beat-and-trim reports found in the trailing 6 months as of this run.</td></tr>]</tbody>
    </table></div>
    <p class="note">Prices are news-search-derived approximations (52-week high, price shortly after the guidance-cut report, and latest available quote), not live market data &mdash; treat as directional. &asymp; indicates an approximate or estimated figure.</p>
  </section>
  <section>
    <h2>Upcoming Earnings — Next 5 Business Days</h2>
    <div class="tablescroll"><table>
      <thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Report Date</th><th>Timing</th><th>Consensus EPS Est.</th></tr></thead>
      <tbody>[one tr per company: <td class="tk">TICKER</td><td>Company</td><td class="ctr">YYYY-MM-DD</td><td class="ctr"><span class="tag-bmo">BMO</span>|<span class="tag-amc">AMC</span>|plain text</td><td class="num">$X.XX or n/a</td>. OR <tr><td colspan="5" class="empty">No large-cap earnings reports scheduled in the next 5 business days.</td></tr>]</tbody>
    </table></div>
    <p class="note">Earnings dates are subject to change; confirm with the company's investor relations page before acting on them.</p>
  </section>
  <section><p class="disc">This is not financial advice. Do your own research.</p></section>
</main>
<footer style="text-align:center;font-size:12px;color:#6a7280;padding:24px;">The Daily Brief &middot; Stock Analysis</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — index.html
Do NOT modify index.html. The dashboard card for this page already exists.
MARK_jobs_stock_analysis_md

cat > jobs/track.md <<'MARK_jobs_track_md'
# track.html — Track & Field Weekly

Cadence: Mondays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/track.csv (athlete)

## Gate
None. Runs every Monday.

## 1 — Week
The 7 days ending yesterday (Sunday). Compute fresh via bash `date`; ISO via `date +%F`.
The edition's data-date is TODAY (Monday); the header reads "Week ending [Sunday DD, YYYY]".

Note: this page previously ran on Sundays and its week ended on a Saturday. It now runs
Mondays and the week ends Sunday. Do not reintroduce the Saturday wording.

## 2 — Roster
Read jobs/rosters/track.csv from the clone — 32 athletes, one per line, in file order.
No fallback roster. A missing or unreadable CSV is a FAILED page.

IMPORTANT — the old version of this job built and PUBLISHED a full-page red error banner when
the roster could not be read, wiping the live page and its entire edition history. Never do
that. A roster that cannot be read is simply a FAILED page under jobs/_publish.md: report the
error and leave the existing track.html untouched. Publishing an error page destroys good
content and is worse than publishing nothing.

The roster carries names ONLY — no school, team or event. Those come from research and belong
in the <h3> and the summary table. Where an athlete's school/team or primary event cannot be
confirmed, write "—" rather than guessing.

## 3 — Stats, the past 7 days
Per athlete: events competed in; results — times, distances, heights, placements; any personal
or season bests set; notable news (injuries, announcements, transfers, records).
- No competitions: "No meets this week."
- Competed but results not findable: "Results unavailable."

Primary sources: worldathletics.org, usatf.org, ESPN Track & Field, MileSplit, FloTrack, and
NCAA/NAIA results pages. WebSearch, run in parallel.

## 4 — YouTube highlights
Per athlete, search for race or event highlight videos published in the LAST 7 DAYS ONLY. Run
these in parallel with the stats searches:
- site:youtube.com "[Athlete]" track race highlights [YYYY]
- "[Athlete]" race highlights site:youtube.com

Discard anything older than 7 days. Up to 2 videos per athlete. Where none are found within
the window, "No recent highlights found."

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Track &amp; Field Weekly &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:32px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:20px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; margin:14px 0 4px; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; } li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  table { border-collapse:collapse; width:100%; font-size:13px; }
  th { background:var(--navy); color:#fff; padding:8px 10px; text-align:left; border:1px solid #ccc; }
  td { padding:7px 10px; border:1px solid #e0e0e0; }
  tr:nth-child(even) td { background:#f4f6fa; }
  .muted { color:var(--muted); font-size:13px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>Track &amp; Field Weekly</h1>
<div class="sub">Latest: week ending [Sun DD, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Track &amp; Field Weekly</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 6 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week ending [Sunday DD, YYYY]</div>
<section><h2>This Week</h2><p>[date range and one line on the standout performance]</p></section>
<section><h2>Athletes</h2>
[per athlete: <h3>Name &mdash; School/Team &mdash; Event</h3><p>This week: [result] &middot; [PB/SB if any] &middot; News: [notable news, or "No meets this week."]</p>]
</section>
<section><h2>Race Highlights</h2>
[per athlete with videos: <h3>Name</h3><ul><li><a href="[URL]" target="_blank">[title]</a></li></ul>; otherwise <p class="muted">No recent highlights found.</p>]
</section>
<section><h2>Quick Summary</h2><table>
<tr><th>Athlete</th><th>School/Team</th><th>Event</th><th>Result</th><th>Notes</th></tr>
[one row per athlete]
</table></section>
</article>

## 7 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_track_md

cat > jobs/rosters/track.csv <<'MARK_jobs_rosters_track_csv'
athlete
Abbey Caldwell
Andrew Coscoran
Anna Hall
Bryce Hoppel
Cathal Doyle
Cian McPhillips
Cole Hocker
Conner Mantz
Donavan Brazier
Ethan Strand
Femke Bol
Gabby Thomas
Grant Fisher
Grant Holloway
Jakob Ingebritson
Jessica Hull
Josh Kerr
Justyna Święty-Ersetic
Katelyn Tuohy
Katie Moon
Laura Nicholson
Liam Murphy
Nico Young
Parker Valby
Rai Benjamin
Sarah Healy
Sifan Hassan
Sinclaire Johnson
Sophie O'Sullivan
Sydney McLaughlin
Trayvon Bromell
Yared Nuguse
MARK_jobs_rosters_track_csv

echo "Created:"
ls -1 jobs/stock-analysis.md jobs/track.md jobs/rosters/track.csv
