#!/usr/bin/env bash
# Adds the Tuesday page specs and rosters to jobs/.
# Run from the repo root, then commit and push to main.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/sap-migration.md <<'MARK_jobs_sap_migration_md'
# sap-migration.html — SAP Migration Tools Intel

Cadence: Tuesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/sap-vendors.csv (tool_type,vendor)

## Gate
None. Runs every Tuesday.

## 1 — Vendor list
Read jobs/rosters/sap-vendors.csv from the clone. Group vendors into sections by tool_type, in
the order the types first appear in the file. No fallback list. A missing or unreadable CSV is
a FAILED page.

A vendor may appear under more than one tool_type (Syniti is under both Data Migration and Data
Management). Cover it fully once, under the first type it appears in, and reference it briefly
under the other.

Do not read CLAUDE.md, About Me folders, or any unrelated file.

## 2 — Research, per vendor
Parallel WebSearch where possible. For each vendor gather:

1. **Quick overview** — one or two sentences on what the vendor's SAP migration tool does and
   its market position.
2. **Press releases within the last 10 days** — news dated inside that exact window. If there
   is nothing, say so explicitly rather than substituting older news. You may separately
   mention the most recent notable older item for context, clearly labeled as outside the
   10-day window.
3. **New product developments** — recent feature releases, roadmap announcements, partnerships,
   platform updates. Need not be within 10 days, but should be recent (2026).
4. **How it uses AI** — only when AI/ML/agentic capability actually came up in research.

### The AI paragraph — the standard is mechanism, not adjective
Do NOT write "AI-powered" or "AI-driven" and move on. Search for what the AI actually does.
Good: "parses ABAP into a meta-model and applies AI-driven rules to flag code eligible for
reversion to standard"; "visually recognizes UI elements via CNNs so tests self-heal when
screens change"; "an agent that turns natural-language requests into structured data changes".
If a vendor's AI claim is vague marketing language with no confirmable mechanism, say that
plainly rather than inventing specifics. Skip the paragraph entirely for vendors where AI did
not come up.

### Unverifiable vendors
If a vendor name cannot be confidently matched to a real company — search returns only
unrelated companies with similar names — say so plainly instead of guessing or fabricating,
and note that it should be double-checked.

Length: roughly 60–150 words per vendor across all parts, more when an AI mechanism paragraph
applies. Include inline source links for verifiable claims.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>SAP Migration Tools Intel &mdash; The Daily Brief</title>
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
  h3 { font-size:15px; color:var(--ink); margin:22px 0 4px; padding-top:18px; border-top:1px solid var(--line); }
  h2 + h3 { margin-top:0; padding-top:0; border-top:none; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>SAP Migration Tools Intel</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; SAP Migration Tools Intel</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
One <section> per tool type. The CSS already draws a divider above each vendor's <h3> except
the first in a section — do not add <hr> tags or blank paragraphs for spacing.

<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">SAP Migration Tools Intel &mdash; Week of [Month D, YYYY]</div>
<section>
<h2>🔧 [Tool Type]</h2>
<h3>[Vendor]</h3>
<p>[Overview]</p>
<p><strong>Press releases (last 10 days):</strong> [findings, or "None found."]</p>
<p><strong>New product developments:</strong> [findings]</p>
<p><strong>How it uses AI:</strong> [mechanism-level detail — omit this paragraph entirely when AI did not come up]</p>
[repeat h3 block per vendor in this tool type]
</section>
[repeat section per tool type]
</article>

## 5 — index.html
Do NOT modify index.html. The dashboard card for this page already exists.

## 6 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_sap_migration_md

cat > jobs/nfl.md <<'MARK_jobs_nfl_md'
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
[for each player WITH news: <h3>Name &mdash; Team</h3><ul><li>summary (Source, Date)</li></ul>]
</section>
<section><h2>No notable news</h2>
<p class="muted">[comma-separated list of players with no news in the window]</p>
</section>
</article>

## 5 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_nfl_md

cat > jobs/music.md <<'MARK_jobs_music_md'
# music.html — Music News

Cadence: Tuesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/music.csv (artist)

## Gate
None. Runs every Tuesday.

## 1 — Roster
Read jobs/rosters/music.csv from the clone and use exactly the artist names in it when
searching. No fallback list. A missing or unreadable CSV is a FAILED page.

## 2 — Per-artist research
Two WebSearches per artist:
- "[Artist] new album song 2026"
- "[Artist] tour dates 2026"

## 3 — Alert searches — MANDATORY, do not skip
Split the roster into two roughly equal halves in file order. Run EIGHT batched OR-queries,
two per watched location:

  first half OR-query  + Houston TX 2026 concert
  second half OR-query + Houston TX 2026 concert
  first half OR-query  + Philadelphia PA 2026 concert
  second half OR-query + Philadelphia PA 2026 concert
  first half OR-query  + "North Carolina" 2026 concert
  second half OR-query + "North Carolina" 2026 concert
  first half OR-query  + Galway Ireland 2026 concert
  second half OR-query + Galway Ireland 2026 concert

These exist specifically to catch tour dates that do not surface in the per-artist searches.
Run all eight every time.

## 4 — What to include
1. Upcoming or newly released songs, albums or EPs
2. New music videos
3. Tour and concert status and upcoming dates — FUTURE DATES ONLY, relative to today's run
   date. Never list a show that has already happened.
4. An alert badge on any artist with a FUTURE date in North Carolina (any city),
   Philadelphia PA, Houston TX, or Galway Ireland.

Badge labels: 📍 NC · 📍 PHILLY · 📍 HOUSTON · 📍 GALWAY — combine when several apply, e.g.
"📍 NC & PHILLY".

Items are 1–2 sentences with source and date. Artists with no recent news go in the "No notable
news this week" list rather than getting their own heading.

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Music News &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --alert-bg:#fde8e8; --alert-text:#b91c1c; --alert-border:#f5c6c6; }
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
  h3:first-child { margin-top:0; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .muted { color:var(--muted); font-size:13px; }
  .alert-badge { display:inline-block; background:var(--alert-bg); color:var(--alert-text); border:1px solid var(--alert-border); border-radius:6px; font-size:11px; font-weight:700; padding:2px 7px; margin-left:8px; vertical-align:middle; letter-spacing:.2px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Music News</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Music News</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 6 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Music News &mdash; Week of [Month D, YYYY]</div>
<section>
<h2>&#127925; New Music &amp; Releases</h2>
[per artist with new music news: <h3>[Artist]</h3><ul><li>...</li></ul>]
</section>
<section>
<h2>&#128198; Tour &amp; Concert News</h2>
[per artist with FUTURE tour dates: <h3>[Artist] <span class="alert-badge">&#128205; NC</span></h3><ul><li>Venue, City &mdash; Date. (Source, Month YYYY)</li></ul>]
</section>
[only if music videos were found: <section><h2>&#127909; Music Videos</h2>...</section>]
<section>
<h2>No notable news this week</h2>
<p class="muted">[comma-separated list of artists with nothing new]</p>
</section>
</article>

## 7 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_music_md

cat > jobs/baseball.md <<'MARK_jobs_baseball_md'
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
MARK_jobs_baseball_md

cat > jobs/rosters/sap-vendors.csv <<'MARK_jobs_rosters_sap_vendors_csv'
tool_type,vendor
Technical Conversion,cbs
Technical Conversion,Mig Now
Technical Conversion,SNP
Data Migration,Data Migration International
Data Migration,Syniti
Data Management,Prospecta
Data Management,Syniti
Data Management,LeverX
Custom Code Management,MIGNOW
Custom Code Management,smartShift
Custom Code Management,Panaya
Testing,Tricentis
Automation Platform,Redwood
Automation Platform,Tern
Security,onapsis
Security,zscaler
MARK_jobs_rosters_sap_vendors_csv

cat > jobs/rosters/nfl.csv <<'MARK_jobs_rosters_nfl_csv'
player
Nakobe Dean
Josh Sweat
Miles Sanders
Carson Wentz
Jahan Dotson
Jaelan Phillips
Reed Blankenship
Kenneth Gainwell
Zach Ertz
Drew Allar
Tyler Warren
AJ Brown
Mekhi Becton
Isaiah Rodgers
De'von Achane
MARK_jobs_rosters_nfl_csv

cat > jobs/rosters/music.csv <<'MARK_jobs_rosters_music_csv'
artist
Pearl Jam
Drayton Farley
Darren Kiely
Kneecap
Tyler Childers
Zach Bryan
Dar Williams
Max McNown
Jason Isbell
Noah Kahan
Sturgill Simpson
Maggie Rogers
The Kilans
Houndmouth
Briston Maroney
Ryan Bingham
Sam Donald
Crane Wives
Hozier
Chris Stapleton
Brandi Carlile
AJR
Ryan Adams
Joy Oladokun
MARK_jobs_rosters_music_csv

cat > jobs/rosters/college-baseball.csv <<'MARK_jobs_rosters_college_baseball_csv'
player,college,position,sport
Ben Tarpey,College of Wooster,P,Baseball
Sam Schaeffer,Haverford College,Inf,Baseball
Miles Newsome,Brown University,Inf,Baseball
Logan Lowe,UNC-Asheville,Inf,Baseball
Caiden Chilausky,UNC-Asheville,OF,Baseball
Jack Brodeur,Queens University,P,Baseball
Jack Goldstein,Rhodes College,P,Baseball
Amare Burrus,Columbia University,Inf,Baseball
Emmett Christian,Tufts College,P,Baseball
Miller Young,Vassar College,,Baseball
Carter Liverman,Ferrum College,P,Baseball
Gabriel Ferrell,Montreat College,Inf,Baseball
Ian Bailey,UNC-Asheville,OF,Baseball
Jack Bolte,Kenyon College,IB,Baseball
Colin Leslie,University of Delaware,P,Baseball
Jackson Niedel,Kenyon College,P,Baseball
Sean Donahue,Case Western Reserve University,C,Baseball
Ethan Goldstein,Haverford College,P,Baseball
Ben Jones,Lynchburg College,IF,Baseball
Logan Sawyer,Brevard College,Inf,Baseball
JJ Thornburg,Rose Hulman College,Inf,Softball
Paisley Russell,UNC Greensboro,P,Softball
Grace Arrington,Methodist University,P,Softball
MARK_jobs_rosters_college_baseball_csv

echo "Created:"
ls -1 jobs/sap-migration.md jobs/nfl.md jobs/music.md jobs/baseball.md jobs/rosters/sap-vendors.csv jobs/rosters/nfl.csv jobs/rosters/music.csv jobs/rosters/college-baseball.csv
