# triangle-nc.html — Triangle NC News Digest

Cadence: every day. History: today + up to 3 prior editions (4 total).
Roster: none.

## Gate
None. Runs every day.

## 1 — Research, last 72 hours
Compute the cutoff: today minus 3 days as YYYY-MM-DD. Append `after:CUTOFF` to every query.

Search each of these separately:
1. Raleigh NC news after:CUTOFF
2. Durham NC news after:CUTOFF
3. Chapel Hill Cary NC news after:CUTOFF
4. Carolina Hurricanes after:CUTOFF   (in season, Oct–Jun)
5. Wake County OR Durham County budget OR crime OR development after:CUTOFF
6. UNC Duke NC State news after:CUTOFF
7. Raleigh Durham business development after:CUTOFF

SKIP any story whose source article is more than 72 hours old — do not include it even if
there is nothing fresher for that topic. Running fewer sections beats running stale content.

Priority: breaking news and public safety · local government decisions (budgets, taxes,
zoning, policy) · major sports (Hurricanes, UNC/Duke/NC State) · business openings, closings
and development · weather and environment · community and culture.

Aim for 4–6 distinct, substantive, Triangle-specific stories. Skip national stories with no
local angle.

Preferred sources: ABC11, WRAL, WUNC, CBS17, News & Observer, Axios Raleigh, Indy Week.

## 2 — Writing style
Prose only. No bullet points, no numbered lists. Each section is a mini-article: the lead
sentence carries the news, the rest adds context and detail, inline links anchor to sources.
3–5 sentences per section.

Section emoji — pick the best fit:
🏒 Hockey/Hurricanes · ⚾ Baseball · 🏀 Basketball · 🏈 Football · 🎓 University/Education ·
🏛 Government/Politics/Budget · 🚨 Crime/Public Safety · 🌡 Weather/Environment ·
🏗 Development/Business · 🤝 Community/Culture · 📊 Economy/Finance

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Triangle NC News Digest &mdash; The Daily Brief</title>
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
  section.digest-card { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2.section-title { font-size:18px; color:var(--navy); margin-bottom:16px; padding-bottom:10px; border-bottom:2px solid var(--line); font-weight:700; }
  p.story { font-size:14.5px; line-height:1.8; color:var(--ink); margin-bottom:0; }
  p.story a { color:#1f5fae; font-weight:600; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  p.story a:hover { border-bottom-color:#1f5fae; }
  .sources { margin-top:32px; border-top:2px solid var(--line); padding-top:18px; }
  .sources-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.8px; color:var(--muted); margin-bottom:10px; }
  .sources ul { list-style:none; padding:0; margin:0; }
  .sources ul li { margin-bottom:4px; }
  .sources ul li a { font-size:13px; color:#1f5fae; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  .sources ul li a:hover { border-bottom-color:#1f5fae; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Triangle NC News Digest</h1>
<div class="sub">Raleigh &middot; Durham &middot; Chapel Hill &middot; Cary &middot; Updated daily &middot; showing the last 4 editions</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[UP TO 3 PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; Triangle NC News Digest</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="YYYY-MM-DD">
<div class="ed-head">[WEEKDAY], [Month] [D], [YYYY]</div>
<section class="digest-card">
<h2 class="section-title">[EMOJI] [HEADLINE — 5–10 words]</h2>
<p class="story">[3–5 sentences, inline links]</p>
</section>
[repeat section.digest-card per story, 4–6 total]
<div class="sources">
<div class="sources-label">Sources</div>
<ul><li><a href="[URL]">[Headline] — [Outlet]</a></li>[one per source used]</ul>
</div>
</article>
