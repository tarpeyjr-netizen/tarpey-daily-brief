# college-football.html — College Football Tracker

Cadence: every day in season, Mondays only in the off-season. History: today + up to 6 prior
editions (7 total). Roster: none — tracked teams are below.

## Gate
IN-SEASON = today is between Aug 20 and the CFP National Championship (mid-January), inclusive.
Build every day.
OFF-SEASON = any other date. Build on Mondays only. If it is the off-season and today is NOT a
Monday, SKIP with the reason "Off-season, non-Monday". A skip is a normal outcome.

In off-season Monday editions the content pivots to recruiting, the transfer portal, the
coaching carousel, signing day and spring practice. Same three-section structure, but Secondary
Teams becomes a short "portal & recruiting notes" list instead of a schedule table, and Top 25
becomes national off-season news. Label the edition header "Off-season weekly".

## 1 — Tracked teams
PRIMARY — news every single day:
- Texas A&M Aggies (FBS, SEC)
- Penn State Nittany Lions (FBS, Big Ten)
- Villanova Wildcats (FCS, Patriot League — first year in the league as of 2026)

SECONDARY — next game date always; preview the day before a game, review the day after:
- Texas Tech Red Raiders · Minnesota Golden Gophers · Georgia Tech Yellow Jackets
- Miami Hurricanes · Duke Blue Devils · North Carolina Tar Heels · Florida Gators
- College of Wooster Fighting Scots (NCAA Division III, North Coast Athletic Conference —
  coverage is thin; use woosterathletics.com, northcoast.org and d3football.com; a schedule
  line and box score is fine)

## 2 — Research
Endpoints (WebFetch handles these ESPN JSON APIs well; the www.espn.com HTML pages return empty):
- AP Top 25: https://site.api.espn.com/apis/site/v2/sports/football/college-football/rankings
- Scoreboard: https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?dates=YYYYMMDD&groups=80&limit=200  (drop groups=80 to include FCS)
- Team schedule: https://site.api.espn.com/apis/site/v2/sports/football/college-football/teams/{id}/schedule?season={YYYY}&seasontype=2
- Team news: https://site.api.espn.com/apis/site/v2/sports/football/college-football/news?team={id}&limit=15

ESPN team IDs: Texas A&M 245 · Penn State 213 · Villanova 222 · Texas Tech 2641 · Minnesota 135 ·
Georgia Tech 59 · Miami 2390 · Duke 150 · North Carolina 153 · Florida 57 · Wooster 2748.

DATE HANDLING: the ESPN JSON date field is UTC (2026-09-04T00:00Z is Thursday Sep 3, 8:00 p.m.
ET). Always convert to ET before writing a day-of-week or kickoff time — do not trust a
summarizer's rendering of the date.

### A. Primary teams — every day
3–6 news items per team from the last 48 hours: injuries, depth chart, coaching, recruiting,
honors, program news. One bullet each, ending with source attribution in parentheses, e.g.
(12thMan.com, Aug. 24). Sources: school athletics sites (12thman.com, gopsusports.com,
villanova.com), StateCollege.com, Philadelphia Inquirer, SI/On3/247Sports team sites,
Yardbarker, local beat outlets. The team news-index pages carry dated headlines and fetch
reliably: https://12thman.com/sports/football/news, https://gopsusports.com/sports/football/news

Game-day segments for primary teams:
- Day before a game — add <h4>Pre-Game: [Opponent]</h4>: opponent record and ranking, kickoff
  time/TV/venue, betting line if available, 3–5 key matchups or storylines, injury report, and
  what a win or loss means. Add <span class="tag tag-preview">Pre-Game</span> to the team's <h3>.
- Day after a game — add <h4>Review: [Final score]</h4>: final score, how the game turned, top
  performers with stat lines, turning point, what it means for the record/rankings, what's next.
  Add <span class="tag tag-gameday">Review</span> to the team's <h3>.
- Both can appear the same day if a team played yesterday and plays tomorrow.

### B. Secondary teams
Always a schedule table with each team's next game: opponent, date, kickoff time ET, TV,
home/away, sorted soonest first. Add AP ranking in the team cell when ranked.
Then, only for secondary teams with a game yesterday or tomorrow:
- Tomorrow → 2–4 sentence preview under an <h3>: records, line, main storyline, key players.
- Yesterday → 2–4 sentence review: final score, top performers, how it happened, record after.
If none apply, keep just the table plus one line noting the next matchup on the calendar.

### C. Top 25 scoreboard
Pull yesterday's scoreboard. Report the final score of every game involving an AP Top 25 team,
excluding games already covered above. Render as a table: matchup (with rankings), final score,
and a note column (upset, overtime, ranked-vs-ranked, blowout). Mark an unranked team beating a
ranked team with <strong>UPSET</strong>.
If no ranked teams played yesterday, say so in one sentence and list upcoming ranked-team games
for the next 7 days with dates, times, TV. Close with a one-line note of the current AP ranking
of any tracked team that is ranked.

## 3 — One-time repo cleanup
An early run wrote a double-extension file that Cloudflare Pages served at /college-football.html,
masking failed publishes. Guarded — a no-op once the file is gone:

if git ls-files --error-unmatch college-football.html.html >/dev/null 2>&1; then
  git rm -q college-football.html.html && echo "removed stray duplicate"
fi

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>College Football Tracker &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --accent:#8a1d2c; }
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
  h3 { font-size:15px; margin:16px 0 4px; }
  h3:first-of-type { margin-top:4px; }
  h4 { font-size:14px; color:var(--accent); margin:14px 0 6px; text-transform:uppercase; letter-spacing:.4px; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; } li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .muted { color:var(--muted); font-size:13px; }
  .tag { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; padding:2px 7px; border-radius:4px; vertical-align:middle; margin-left:6px; }
  .tag-primary { background:#1f3a5f; color:#fff; }
  .tag-gameday { background:var(--accent); color:#fff; }
  .tag-preview { background:#e8edf5; color:var(--navy); }
  .nextgame { font-size:13px; color:var(--muted); border-left:3px solid var(--line); padding-left:10px; margin:4px 0 8px; }
  table { width:100%; border-collapse:collapse; margin-top:8px; font-size:13.5px; }
  th { text-align:left; font-size:11.5px; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); border-bottom:1px solid var(--line); padding:6px 8px 6px 0; }
  td { padding:7px 8px 7px 0; border-bottom:1px solid var(--line); line-height:1.45; }
  .tbl-wrap { overflow-x:auto; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>College Football Tracker</h1>
<div class="sub">Latest: [LONG DATE] &middot; Primary teams daily &middot; Secondary teams around game days &middot; Top 25 scoreboard</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[UP TO 6 PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; College Football Tracker &middot; updated daily at 5:00 a.m. ET</footer>
<script>document.querySelectorAll('main a[href^="http"]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="YYYY-MM-DD">
<div class="ed-head">Edition for [Weekday], [Month] [D], [YYYY] &middot; [Week N of the 2026 season | Bowl season | Off-season weekly]</div>
<section>
<h2>Primary Teams</h2>
<h3>[Team] <span class="tag tag-primary">[AP rank or conference]</span></h3>
<div class="nextgame">Next: [Day, Month D] [vs./at] [Opponent] &middot; [time ET] &middot; [TV] &middot; [venue]</div>
<ul><li>[news item] ([Source], [date])</li></ul>
</section>
<section>
<h2>Secondary Teams</h2>
<p class="muted">Next game dates below. A full preview runs the day before each game and a review the day after.</p>
<div class="tbl-wrap"><table>
<thead><tr><th>Team</th><th>Next Game</th><th>Date &amp; Time (ET)</th><th>TV</th></tr></thead>
<tbody><tr><td><strong>[Team]</strong></td><td>[vs./at Opponent]</td><td>[Day, Mon D] &middot; [time]</td><td>[TV]</td></tr></tbody>
</table></div>
</section>
<section>
<h2>Top 25 Scoreboard</h2>
<div class="tbl-wrap"><table>
<thead><tr><th>Matchup</th><th>Final</th><th>Note</th></tr></thead>
<tbody><tr><td>[No. X Team] at [No. Y Team]</td><td>[24-17]</td><td>[note]</td></tr></tbody>
</table></div>
<p class="muted">[AP ranking line for tracked teams.]</p>
</section>
</article>

## 6 — index.html — EXCEPTION
This spec is permitted to touch index.html. Check the dashboard card exists:

  grep -q "href='/college-football'" index.html || echo "CARD_MISSING"

If CARD_MISSING, insert this line immediately before the line containing href='/sports',
preserving indentation, and stage index.html alongside college-football.html:

      <a class='card' href='/college-football'><h2>College Football Tracker</h2><div class="desc">Daily news on Texas A&amp;M, Penn State &amp; Villanova with extended coverage around game days, next-game dates and previews/reviews for 8 secondary teams, plus a Top 25 scoreboard.</div><div class="meta">Updated daily at 5:00 AM</div></a>
