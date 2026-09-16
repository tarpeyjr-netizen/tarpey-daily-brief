# nba.html — NBA Recap

Cadence: weekly on Wednesdays in season; the first Wednesday of the month in the off-season.
History: today's edition + up to 5 prior (6 total).
Roster: jobs/rosters/nba.csv (player,team)

## Gate
IN-SEASON = today falls between October 1 and the end of the NBA Finals (typically mid-to-late
June), inclusive. Build every Wednesday.

OFF-SEASON = any other date (roughly July 1 – September 30). Build only on the FIRST Wednesday
of the month. If it is the off-season and today is not the first Wednesday, SKIP with the
reason "Off-season, not the first Wednesday". A skip is a normal outcome, not a failure.

Determine the first Wednesday with:
  python3 -c "import datetime; d=datetime.date.today(); print(d.weekday()==2 and d.day<=7)"

## 1 — Roster
Read jobs/rosters/nba.csv from the clone. Cover every player, in file order. A player with no
news still gets a paragraph saying so and re-framing his current status. No fallback roster and
no warning banner. A missing or unreadable CSV is a FAILED page.

This page tracks Villanova alumni in the NBA, the G-League and overseas.

ROSTER ACCURACY RULES — these exist because past editions regressed:
1. The team in the CSV is the LAST KNOWN team, not a fact. Confirm each player's current club
   before writing his heading. If a player has moved, update the <h3>, say so in the paragraph,
   and update jobs/rosters/nba.csv in the same commit so the next run starts from the truth.
2. Jermaine Samuels specifically: the July 25, 2026 edition reported his move to San Pablo
   Burgos and the August 7, 2026 edition then reverted him to Houston. That was a regression.
   Establish a player's current club from a dated source, and never describe a departed player
   as still with his old organization.
3. Never restate a stale fact as new. If nothing has changed since the previous edition, say
   that plainly rather than re-reporting old news as current.
4. If a player retires, signs overseas long-term, or otherwise leaves the NBA/G-League orbit,
   keep covering him but note the change in status — do not silently drop him.

## 2 — Research window
Read the previous edition's data-date out of the cloned nba.html. The window runs from the day
after that date through today. Compute the number of days and use it in the header sub-line.
In season that will be about 7 days; in the off-season about 28. If there is no prior edition,
use 30 days.

Report only what is new inside that window.

In-season content: playing time, statistical trends since the last edition, injuries, role
changes, notable individual games, team standing context.
Off-season content: contracts and extensions, trades, Summer League, training-camp invites,
two-way and G-League signings, overseas moves, injury rehab timelines, off-court news.

Sources:
- ESPN NBA API (WebFetch handles these JSON endpoints well; www.espn.com HTML returns empty):
  - Teams: https://site.api.espn.com/apis/site/v2/sports/basketball/nba/teams
  - Team news: https://site.api.espn.com/apis/site/v2/sports/basketball/nba/news?team={teamId}&limit=15
  - Scoreboard: https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates=YYYYMMDD
  - Team schedule: https://site.api.espn.com/apis/site/v2/sports/basketball/nba/teams/{teamId}/schedule
  Resolve team and athlete IDs at run time — do not assume hardcoded athlete IDs.
- WebSearch for narrative and transaction news: player name plus the window's month.
- Team beat outlets, league transaction wires, RealGM, Basketball Reference, the G-League site
  for two-way and call-up movement, and the relevant European league sites for players abroad.
- villanova.com for alumni features.

Every claim about a signing, trade, injury or stat line must trace to something retrieved in
this run. An unconfirmed rumor is either omitted or marked reported-but-unconfirmed with the
outlet named.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>NBA Update &mdash; The Daily Brief</title>
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
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>NBA Update</h1>
<div class="sub">Latest: [LONG DATE] &middot; covering the last [N] days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[UP TO 5 PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; NBA Update</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">[Month] [D], [YYYY] Update &middot; [In-season update | Off-season update]</div>
<section><h2>Roster Players</h2>
<h3>[Player] &mdash; [Current Team]</h3>
<p>[One paragraph, 60–140 words. Lead with what is NEW in the window. Include stat lines, contract figures and dates where they exist. If nothing is new, say so in the first clause and re-frame his current status in one or two sentences.]</p>
[repeat for all players, in CSV order]
</section>
</article>

Style: match the existing editions — plain declarative sentences, no bullet lists inside player
paragraphs, no headers beyond h2/h3, figures written as in prior editions (12.7 / 4.1 / 4.6,
40.1% from three, four-year, $48M). Use &mdash; for the em dash in headings and &ndash; for
date ranges. No emoji.

## 5 — index.html — EXCEPTION
This spec is permitted to touch index.html. The /nba card must read:

      <a class='card' href='/nba'><h2>NBA Recap</h2><div class="desc">Recaps for tracked Villanova alumni in the NBA, the G-League and overseas.</div><div class="meta">Updated Wednesdays in season, monthly in off-season</div></a>

Replace the existing /nba card line if it does not already match, preserving indentation, and
stage index.html alongside nba.html.

## 6 — Merge
Keep up to 5 prior editions (6 total including today).
