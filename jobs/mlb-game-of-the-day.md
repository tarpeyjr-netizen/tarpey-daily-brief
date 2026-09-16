# mlb-game-of-the-day.html — MLB Game of the Day

Cadence: every day in season. History: rolling 8-day window, keyed off the GAME date.
Roster: none.

## Gate — check this FIRST, before any research
This page is seasonal and it skips often. Both skips below are normal outcomes, not failures.

1. SEASON GATE. The MLB regular season runs roughly late March through early October, plus
   the postseason into early November. If today falls outside that window (roughly November
   through mid-March), SKIP immediately with the reason "MLB off-season — no games". Do not
   search. This saves a full research pass on every one of ~140 dormant days a year.
2. OFF-DAY GATE. In season, if no MLB games were completed yesterday (All-Star break, a
   league-wide off day), SKIP with the reason "No MLB games played [yesterday's date]".
   Do not publish a placeholder edition and do not force a non-game story.

Postponed or suspended games are never eligible as the game of the day.

## 1 — Date
Everything is about games PLAYED YESTERDAY (completed/final only).
  date -d yesterday +%F                     ISO, used as data-date
  date -d yesterday +"%A, %B %-d, %Y"       long form
Note: data-date is YESTERDAY, not today. This page is the only one keyed that way.

## 2 — Gather yesterday's slate
Find every completed game and its final score / box score. WebSearch and fetch against
https://www.espn.com/mlb/scoreboard/_/date/YYYYMMDD (no dashes) and MLB.com.
Pull final score, line score (runs by inning, hits, errors), starting pitcher decisions, and
notable stat lines for each completed game.

## 3 — Pick the most intriguing game
Score every completed game and select ONE, in rough priority order:
1. No-hitter or perfect game (combined or solo)
2. A player with 3+ home runs, or hitting for the cycle
3. A milestone (500th HR, 3,000th hit, 3,000th K, a rare defensive feat)
4. A team clinching a playoff spot or division, or taking over first place
5. A walk-off, an extra-inning classic, or a comeback erasing a 5+ run deficit
6. A dominant pitching performance (15+ K, complete-game shutout)
7. Any other unusual or historic storyline (triple play, ejection controversy, notable debut)

Pick the best story, not the highest-profile teams. If nothing stands out, take the best
individual storyline — best pitching duel, most dramatic finish — and say so plainly in the
writeup rather than manufacturing drama.

## 4 — Research the selected game
Final score · line score by inning (R/H/E) · winning/losing/save pitchers with their lines ·
home run details (batter, inning, distance/exit velo if available) · key plays in sequence,
especially late · standings or playoff context if that is why the game was chosen.

## 5 — Write the recap, newspaper style
Headline — punchy and specific, like a real sports section. "Judge's Three Homers Power
  Yankees Past Rivals", not "Yankees Win Big Game".
Kicker — one line naming the city and the core reason this game was picked.
Lede — 2–3 sentences: the outcome and the headline storyline.
Body — 3–5 short paragraphs of newspaper prose: how it unfolded, the turning point, context
  (standings implications, streaks, season narrative).
Standout performances — stat lines for the 2–4 most important players. MUST include at least
  one pitcher's line. If the winning pitcher was unremarkable, include whoever was most
  relevant to the outcome — the decision-getter, or the pitcher who allowed or prevented the
  key runs. Never omit pitching entirely.
Tone: engaging sportswriting, vivid but factual. No invented quotes or details.

## 6 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>MLB Game of the Day &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --accent:#a3231f; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:Georgia,'Times New Roman',serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:820px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:36px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:24px; }
  .ed-head { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:10px; }
  .kicker { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.8px; color:var(--accent); margin-bottom:8px; }
  h2.headline { font-size:26px; line-height:1.25; margin-bottom:10px; color:var(--ink); }
  .score-line { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:14px; font-weight:700; color:var(--navy); margin-bottom:16px; }
  .lede { font-size:17px; line-height:1.6; margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:18px; }
  section h3 { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:13px; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); margin-bottom:12px; }
  p { font-size:15px; line-height:1.7; margin-bottom:10px; }
  p:last-child { margin-bottom:0; }
  table { border-collapse:collapse; width:100%; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:13px; }
  th { background:var(--navy); color:#fff; padding:8px 10px; text-align:center; border:1px solid #ccc; }
  th:first-child { text-align:left; }
  td { padding:7px 10px; border:1px solid #e0e0e0; text-align:center; }
  td:first-child { text-align:left; font-weight:600; }
  tr:nth-child(even) td { background:#f4f6fa; }
  .stat-line { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:14px; line-height:1.6; margin-bottom:8px; }
  .stat-line b { color:var(--navy); }
  footer { text-align:center; font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>MLB Game of the Day</h1>
<div class="sub">One standout game from the day before, told newspaper-style &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[NEW EDITION — data-date is YESTERDAY]
[PRIOR EDITIONS 1–8 DAYS OLD]
</main>
<footer>The Daily Brief &middot; MLB Game of the Day</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 7 — New edition block
<article class="edition" data-date="[YESTERDAY ISO]">
<div class="ed-head">Game played [yesterday's long date]</div>
<div class="kicker">[Why picked — "No-Hitter" / "Walk-Off Win" / "First Place Showdown"]</div>
<h2 class="headline">[Newspaper headline]</h2>
<div class="score-line">[Winner] [score], [Loser] [score] &mdash; Final[/ extra innings note]</div>
<p class="lede">[2–3 sentence lede]</p>
<section><h3>The Game</h3>[3–5 short paragraphs]</section>
<section><h3>Line Score</h3><table><tr><th>Team</th>[innings played]<th>R</th><th>H</th><th>E</th></tr>[one row per team]</table></section>
<section><h3>Standout Performances</h3>[<p class="stat-line"><b>Name</b> (Team) &mdash; stat line</p> per key player; at least one pitcher]</section>
</article>

## 8 — Merge
Keep prior editions whose data-date is 1–8 days before today. Note this window keys off the
GAME date, so it runs one day behind the other pages.

## 9 — index.html
Do NOT modify index.html. The dashboard tile for /mlb-game-of-the-day already exists.
