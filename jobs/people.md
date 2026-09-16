# people.html — People Update

Cadence: Wednesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/people.csv (person,profession)

## Gate
None. Runs every Wednesday.

## 1 — Week
The 7 days ending yesterday. Compute fresh via bash `date`; ISO via `date +%F`.

## 2 — Roster
Read jobs/rosters/people.csv from the clone. Cover every person, in file order. No fallback
roster and no warning banner. A missing or unreadable CSV is a FAILED page.

This roster is long — pace the research so every person gets covered. Nobody is skipped: a
person with no news gets "No major updates this week."

## 3 — Research, last 7 days
Per person, parallel WebSearch:
- "[Name] news 2026"
- "[Name] interview 2026"
- "[Name] book article podcast 2026"
- "[Name] podcast appearance 2026" / "[Name] podcast interview this week"

Capture: new books, projects or interviews published; podcast appearances (show name, host,
date, and a notable quote or topic — this is a priority category, not an afterthought);
notable quotes; awards; sporting results (Fouts, Bueckers); tournament results (Carlsen);
notable commentary or op-eds.

If a person had a podcast appearance this week, prefer it as their highlight unless a clearly
bigger story exists.

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>People Update &mdash; The Daily Brief</title>
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
<h1>People Update</h1>
<div class="sub">Latest: week ending [Wed DD, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; People Update</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week ending [Wednesday DD, YYYY]</div>
<section><h2>This Week</h2><p>[One or two sentences: the most interesting update of the week across everyone]</p></section>
<section><h2>Updates</h2>
[per person: <h3>Name &mdash; Profession</h3><p>Update: [what happened, what was published, what was said — specific and interesting, quote if notable. If nothing: "No major updates this week."]</p>]
</section>
</article>

## 6 — Merge
Keep prior editions dated 1–7 days before today.
