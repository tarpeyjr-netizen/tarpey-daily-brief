# cities.html — US City News Digest

Cadence: every day. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/cities.csv (day,primary_city,secondary_city)

## Gate
None. Runs every day.

## 1 — Today's cities
Read jobs/rosters/cities.csv from the clone and match on today's day of month (1–31).
No fallback table, no roster warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Primary city — 1–2 substantive stories, last 30 days
Topics: Government & Politics (council, mayor, elections, policy) · Crime & Justice ·
Economics & Business (employers, development, real estate) · Science & Environment
(research institutions, environmental issues, infrastructure) · Collegiate or amateur sports.

EXCLUDE professional sports scores, standings and transactions — those belong to other pages.
A pro team may appear in a stadium-deal, economic or community-impact story, but never as a
sports recap.

Source preference, in order:
1. Local newspapers (Seattle Times, Boston Globe, Denver Post, Houston Chronicle, …)
2. Local TV news sites (kiro7.com, wsb-tv.com, fox29.com, …)
3. NPR affiliates and local public radio
4. City or county .gov news pages
5. patch.com for neighborhood-level stories
6. NYTimes.com and WashingtonPost.com — subscriber access assumed, fine to use
Avoid WSJ, Bloomberg, Politico, The Atlantic and other national outlets unless the story is
specifically local.

Per story: a prose paragraph of 3–6 sentences — what happened, who is involved, what it means
for the city — as narrative, not a headline list. Weave 1–2 inline hyperlinks into the prose
(link key phrases, never "click here"). Then a "Read more" line with the 2–3 most useful URLs
under short labels.

Run 2–3 searches: "[City] local news [month year]", "[City] government OR crime OR business [month year]".

## 3 — Secondary city — 3–5 links, last 30 days
Run 1–2 searches: "[City] news [month year]", "[City] local [topic] [year]". Mix topics
(government, business, community, culture, sports if notable). Same source preferences.
Per link: the headline as a hyperlink plus one sentence describing the story. No prose
paragraphs — this section is intentionally lighter.

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>US City News Digest &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --accent:#d97706; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:40px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:28px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:18px; }
  .city-card { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  .city-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.8px; color:var(--accent); margin-bottom:6px; }
  h2.city-name { font-size:20px; font-weight:700; color:var(--navy); margin-bottom:16px; }
  .story { margin-bottom:20px; padding-bottom:20px; border-bottom:1px solid var(--line); }
  .story:last-of-type { border-bottom:none; margin-bottom:0; padding-bottom:0; }
  h3.story-topic { font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); border-left:3px solid var(--navy); padding-left:8px; margin-bottom:10px; }
  p.story-body { font-size:14.5px; line-height:1.75; color:var(--ink); margin-bottom:10px; }
  p.story-body a { color:#1f5fae; font-weight:600; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  p.story-body a:hover { border-bottom-color:#1f5fae; }
  .read-more { font-size:12.5px; color:var(--muted); }
  .read-more a { color:#1f5fae; text-decoration:none; margin-right:12px; }
  .read-more a:hover { text-decoration:underline; }
  .secondary-card { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2.sec-city-name { font-size:20px; font-weight:700; color:var(--navy); margin-bottom:14px; }
  ul.hot-links { list-style:none; padding:0; }
  ul.hot-links li { padding:10px 0; border-bottom:1px solid var(--line); font-size:14px; line-height:1.5; }
  ul.hot-links li:last-child { border-bottom:none; }
  ul.hot-links a { font-weight:600; color:#1f5fae; text-decoration:none; }
  ul.hot-links a:hover { text-decoration:underline; }
  ul.hot-links .link-desc { display:block; font-size:13px; color:var(--muted); margin-top:2px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>US City News Digest</h1>
<div class="sub">Daily city spotlight &middot; [PRIMARY] &amp; [SECONDARY] &middot; [DATE LABEL] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; US City News Digest</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">[WEEKDAY], [Month] [D], [YYYY]</div>
<div class="city-card">
  <div class="city-label">&#x1F3D9; Primary</div>
  <h2 class="city-name">[Primary City]</h2>
  <div class="story">
    <h3 class="story-topic">[Government / Crime / Business / Science / Collegiate Sports]</h3>
    <p class="story-body">[3–6 sentences, inline links]</p>
    <div class="read-more">Read more: <a href="[URL1]">[Label]</a> <a href="[URL2]">[Label]</a></div>
  </div>
  [repeat .story for the second story if there is one]
</div>
<div class="secondary-card">
  <div class="city-label">&#x1F4CD; Secondary</div>
  <h2 class="sec-city-name">[Secondary City]</h2>
  <ul class="hot-links">
    <li><a href="[URL]">[Headline]</a><span class="link-desc">[One sentence.]</span></li>
    [3–5 items]
  </ul>
</div>
</article>

## 6 — Merge
Keep prior editions dated 1–7 days before today. Drop anything older.
