# mlb.html — MLB Weekly Recap

Cadence: Wednesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/mlb.csv (player,team,position — P = pitcher; blank team = prospect/unsigned)

## Gate
None beyond the routine's schedule. The season state changes what you report, it never skips:
- Regular season or postseason — last 7 days of stats as below.
- Spring training — spring training stats instead.
- Season over (roughly November through February) — a short wrap-up per player: final season
  line, contract or free-agency status, offseason news. Say plainly that the season is over.

## 1 — Week
The 7 days ending yesterday (Tuesday). Compute fresh via bash `date`; ISO via `date +%F`.
The edition's data-date is TODAY (Wednesday); the header reads "Week ending [Tuesday DD, YYYY]".

## 2 — Roster
Read jobs/rosters/mlb.csv from the clone. Cover every player, in file order. A player with a
blank team is a prospect or unsigned — cover minor-league, college or draft news for him and
say where he currently is. No fallback roster, no warning banner. A missing or unreadable CSV
is a FAILED page.

## 3 — Stats, last 7 days
Pitchers: appearances/starts, IP, ERA, K, WHIP, W–L, standout outings.
Hitters: GP, AVG, H, HR, RBI, OPS/SLG, standout games.
Every player: any news — injury or IL move, trade, roster move, option, call-up, demotion.
If a player was inactive all week, say so rather than omitting him.

Sources: ESPN, Baseball Reference, MLB.com. Parallel WebSearch. On a week with no games for a
player (off-days, IL), report news only.

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>MLB Weekly Recap &mdash; The Daily Brief</title>
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
<h1>MLB Weekly Recap</h1>
<div class="sub">Latest: week ending [Tue DD, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; MLB Weekly Recap</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week ending [Tuesday DD, YYYY]</div>
<section><h2>This Week</h2><p>[date range and one line on the top performer]</p></section>
<section><h2>Players</h2>
[per player: <h3>Name &mdash; Team &mdash; Pos</h3><p>This week: ... &middot; Stats: ... &middot; Highlights: ... &middot; News: ...</p>]
</section>
<section><h2>Quick Summary</h2><table>
<tr><th>Player</th><th>Team</th><th>Role</th><th>Key stats</th><th>Status</th></tr>
[one row per player; Status is exactly Healthy, Issue, or IL/Out]
</table></section>
</article>

## 6 — Merge
Keep prior editions dated 1–7 days before today.
