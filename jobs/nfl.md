# nfl.html — NFL Player News

Cadence: Tuesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/nfl.csv (player)

## Gate
None. Runs every Tuesday, in season and out — roster moves, signings and injury news continue
year round.

## 1 — Roster
Read jobs/rosters/nfl.csv from the clone. No fallback roster and no warning banner. A missing
or unreadable CSV is a FAILED page.

## 2 — Research
One WebSearch per player: "<Player Name>" NFL news

Include only items dated within the last 14 days. One sentence per item, about 25 words max,
with the source publication and date. No long quotes.

Because this page runs weekly against a 14-day window, consecutive editions overlap. Read the
previous edition in the cloned nfl.html before writing and do not repeat an item it already
carried — cover only what is new since that edition, unless there is a genuine development on
the same story, in which case say what changed.

### Links to major publications
Every news item must carry an inline link to the article. Prefer major outlets: The Athletic,
Sports Illustrated, The Ringer, ESPN, NFL.com, Yahoo Sports, CBS Sports, NBC Sports, Pro Football
Talk, team sites. The link goes on the source name, e.g. <a href="URL">(ESPN, Oct. 5, 2026)</a>.
Use only URLs that appeared in search results; never construct or guess a link. If only an
aggregator (Rotowire, etc.) is available, link that rather than omit the link.

### Season stats (regular season and playoffs only)
IN-SEASON = the first NFL game of the regular season through the Super Bowl. During that window,
add a season-to-date stat line under each player's heading, for EVERY roster player, including
those listed under "No notable news" (give those a compact "Name (Team): stat line" entry with a
link to the stats source). Use the position-appropriate line, e.g. QB: GP, comp/att, yds, TD, INT,
rating; RB: GP, att, yds, avg, TD, rec, rec yds; WR/TE: GP, rec, tgt, yds, TD; defense: GP, tackles,
sacks, TFL, INT, FF, PD. Sources in order: NFL.com or team site, ESPN, Pro-Football-Reference,
then WebSearch. If stats are not findable, write "Stats unavailable" with the URL checked. Never
estimate. Off-season: omit stats and say nothing about them.

Players with no qualifying news are not written up individually; they are listed together in
the "No notable news" section.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>NFL Player News &mdash; The Daily Brief</title>
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
<h1>NFL Player News</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; NFL Player News</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Digest for [Month D, YYYY] &middot; window: past 14 days</div>
<section><h2>Player News</h2>
[for each player WITH news: <h3>Name &mdash; Team</h3><p class="muted">Season stats: [line, in season only]</p><ul><li>summary (<a href="URL">Source, Date</a>)</li></ul>]
</section>
<section><h2>No notable news</h2>
<p class="muted">[comma-separated list of players with no news in the window]</p>
</section>
</article>

## 5 — Merge
Keep prior editions dated 1–7 days before today.
