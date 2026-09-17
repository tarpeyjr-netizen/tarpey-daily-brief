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
