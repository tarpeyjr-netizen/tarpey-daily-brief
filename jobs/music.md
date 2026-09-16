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
