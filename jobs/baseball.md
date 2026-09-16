# baseball.html — College Baseball & Softball Weekly

Cadence: Tuesdays, in season only. History: rolling 8-day window (today + prior editions
1–7 days old). Roster: jobs/rosters/college-baseball.csv (player,college,position,sport)

## Gate
IN-SEASON = February 1 through June 30, which covers spring practice, the regular season, the
conference tournaments, the NCAA regionals and the College World Series.

OFF-SEASON = July 1 through January 31. SKIP with the reason "College baseball off-season — no
games". Do not search. Outside the season every player returns "No games this week", so a full
23-player research pass produces nothing but a page of blanks.

## 1 — Week window
The 7 days ending the previous Sunday. Compute fresh via bash `date`; ISO via `date +%F`.
The edition's data-date is TODAY; the header reads "Week of [Mon DD] to [Sun DD, YYYY]".

## 2 — Roster
Read jobs/rosters/college-baseball.csv from the clone. Split by the sport column into Baseball
and Softball, then by position into Pitchers (P) and Hitters (everything else — Inf, IF, OF, C,
IB, or blank). No fallback roster and no warning banner. A missing or unreadable CSV is a
FAILED page.

## 3 — Stats, weekly and season to date
Pitchers (both sports): GP, IP, W–L, ERA, WHIP, K, BB, H, R/ER, opponent AVG.
Hitters (both sports): GP, AB, H, 2B, 3B, HR, RBI, R, BB, SO, SB, AVG/OBP/SLG/OPS.

Sources in order:
1. The school's own athletics site
2. NCAA.com, D3baseball.com, D3softball.com, or the conference page
3. WebSearch

Use WebFetch and WebSearch. Coverage at this level is thin and uneven — that is expected.
- No games in the window: "No games this week."
- Stats genuinely not findable: "Stats unavailable — check <URL>." Name the URL you checked.
Never estimate or infer a stat line.

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>College Baseball &amp; Softball Weekly &mdash; The Daily Brief</title>
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
  .muted { color:var(--muted); font-size:13px; }
  .sport-label { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; padding:2px 8px; border-radius:20px; margin-bottom:10px; }
  .sport-label.baseball { background:#dbeafe; color:#1e40af; }
  .sport-label.softball { background:#fce7f3; color:#9d174d; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>College Baseball &amp; Softball Weekly</h1>
<div class="sub">Latest: week of [Mon DD] to [Sun DD, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; College Baseball &amp; Softball Weekly</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week of [Mon DD] to [Sun DD, YYYY]</div>
<section><h2>This Week</h2><p>[week window and a one-line top performer from each sport]</p></section>
<section><h2>Baseball &mdash; Pitchers</h2><span class="sport-label baseball">Baseball</span>
[per pitcher: <h3>Name &mdash; College &mdash; Position</h3><p>Weekly: ...</p><p>Season: ...</p> optional one-line note]
</section>
<section><h2>Baseball &mdash; Hitters</h2><span class="sport-label baseball">Baseball</span>
[per hitter, same shape]
</section>
<section><h2>Softball &mdash; Pitchers</h2><span class="sport-label softball">Softball</span>
[per pitcher, same shape]
</section>
<section><h2>Softball &mdash; Hitters</h2><span class="sport-label softball">Softball</span>
[per hitter, same shape]
</section>
<section><h2>Sources</h2><p class="muted">[the sources used]</p></section>
</article>

## 6 — Merge
Keep prior editions dated 1–7 days before today.
