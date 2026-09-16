# world-news.html — World News Digest

Cadence: every day. History: today's edition + up to 5 prior (6 total).
Roster: jobs/rosters/countries.csv (day,country,population,continent)

## Gate
None. Runs every day.

## 1 — Today's country
Read jobs/rosters/countries.csv from the clone. Match rows on today's day of month (1–31).
Some days have TWO rows (19, 20, 21, 22) — cover both countries, one country-card each.
Use the population and continent columns verbatim in the country-meta line.

There is no fallback table and no roster warning banner. The CSV is in the clone; if it is
missing or unreadable, that is a FAILED page, not a fallback.

## 2 — Research each country

### A. News — 5–8 articles, past 7 days
Cover these topic areas:
- Politics & Government — elections, legislation, leadership, diplomacy
- Economy & Business — GDP, trade, major companies, employment, currency
- Military & Security — conflicts, defence spending, border tensions, terrorism
- Society & Culture — protests, education, health, religion, demographics
- Tourism — visitor numbers, new attractions/routes, travel advisories, hospitality, festivals
- Science & Technology — research breakthroughs, infrastructure, environment, tech

Each topic area becomes ONE prose paragraph (3–5 sentences) with inline hyperlinks — link
key phrases directly to sources rather than listing headlines. It should read as a coherent
news summary, not a list. Aim for 2–4 source links woven naturally into each paragraph.

Omit a topic area entirely if it has no news in the last 7 days. Do not force it.

Within Tourism, add a second paragraph after the news one: pick one specific well-known
attraction, landmark or destination (UNESCO site, national park, historic district) and
write 2–3 sentences on what it is, why it is notable, and one practical visiting detail
(entry cost, best time, how to get there). One inline hyperlink. Prefix it with
<strong>Site to visit:</strong> and put it in its own <p class="topic-summary">.

### B. Trending — 1 item per country
Find something with grassroots momentum right now: a local tech product or startup, an indie
musician going viral, a consumer phenomenon, a cultural movement. Authentic local origin and
organic momentum — NOT mainstream celebrities or government initiatives. Use 1–2 searches.
Collect: name, category, city/region of origin, the story of its rise, 1–2 source URLs.

### Sources
Prefer (non-paywalled): BBC, Reuters, AP News, The Guardian, Al Jazeera, France 24,
Deutsche Welle, RFI, NHK World, Times of India, The Hindu, Daily Nation (Kenya),
Premium Times (Nigeria), Global Voices, reputable local English-language outlets.
Avoid (paywalled): New York Times, Wall Street Journal, Financial Times, The Economist, Bloomberg.

## 3 — Page shell
Build the complete file. Build stamp first line, above the doctype. Do not alter the CSS
variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>World News Digest &mdash; The Daily Brief</title>
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
  section.country-card { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2.country-name { font-size:20px; color:var(--navy); margin-bottom:4px; }
  .country-meta { font-size:12px; color:var(--muted); margin-bottom:16px; }
  h3.topic { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); margin-top:20px; margin-bottom:8px; border-left:3px solid var(--navy); padding-left:8px; }
  h3.topic:first-of-type { margin-top:0; }
  p.topic-summary { font-size:14.5px; line-height:1.75; color:var(--ink); }
  p.topic-summary a { color:#1f5fae; font-weight:600; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  p.topic-summary a:hover { border-bottom-color:#1f5fae; }
  .trending-box { margin-top:24px; border-top:2px solid var(--line); padding-top:18px; }
  .trending-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.8px; color:#e07b00; margin-bottom:6px; }
  .trending-title { font-size:16px; font-weight:700; color:var(--navy); margin-bottom:2px; }
  .trending-meta { font-size:12px; color:var(--muted); margin-bottom:10px; }
  p.trending-summary { font-size:14px; line-height:1.75; color:var(--ink); }
  p.trending-summary a { color:#1f5fae; font-weight:600; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  p.trending-summary a:hover { border-bottom-color:#1f5fae; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class='back' href='/'>&larr; Back to dashboard</a>
<h1>World News Digest</h1>
<div class="sub">Daily country deep-dive &middot; [COUNTRY NAME] &middot; [DATE_LABEL] &middot; showing the last 6 editions</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[UP TO 5 PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; World News Digest</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
One <section class="country-card"> per country assigned today, each with its own trending-box.

<article class="edition" data-date="YYYY-MM-DD">
<div class="ed-head">[WEEKDAY], [Month] [D], [YYYY] &middot; [CONTINENT]</div>
<section class="country-card">
<h2 class="country-name">[Country]</h2>
<div class="country-meta">[Continent] &middot; population [population from CSV]</div>
<h3 class="topic">Politics &amp; Government</h3>
<p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Economy &amp; Business</h3>
<p class="topic-summary">[3–5 sentences, inline links]</p>
[Military &amp; Security, Society &amp; Culture as available]
<h3 class="topic">Tourism</h3>
<p class="topic-summary">[3–5 sentences, inline links]</p>
<p class="topic-summary"><strong>Site to visit:</strong> [2–3 sentences, one link]</p>
[Science &amp; Technology as available]
<div class="trending-box">
  <div class="trending-label">&#x1F525; Trending</div>
  <div class="trending-title">[Name]</div>
  <div class="trending-meta">[Category] &middot; [City/Region]</div>
  <p class="trending-summary">[3–5 sentences, 1–2 inline links]</p>
</div>
</section>
</article>
