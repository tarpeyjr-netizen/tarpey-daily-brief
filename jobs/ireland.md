# ireland.html — Ireland Weekly Digest

Cadence: Saturdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: none — the section list is below.

## Gate
None. Runs every Saturday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run the section searches in
parallel, one per section, 8 results max each. Do not browse full pages unless a headline is
unclear. Keep the whole digest under about 1,200 words.

## 1 — Research, the past 7 days
Irish-focused WebSearch: site:rte.ie, site:irishtimes.com, site:independent.ie,
site:thejournal.ie, site:galwaybayfm.ie.

Ten sections, 3–5 short bullets each, 1–2 sentences per bullet, in this order:

1. **Politics** — Ireland
2. **Economics** — Ireland
3. **Military / Defence Forces**
4. **Technology** — Irish tech and multinationals in Ireland
5. **Sports** — GAA, rugby, soccer, Galway teams
6. **Music** — Irish artists, releases, gigs
7. **Books** — Irish authors, releases, prizes
8. **Galway news** — city and county
9. **Kilkelly news** — the Mayo village. If there is nothing, cover east Mayo, Charlestown,
   Swinford, or parish notes instead
10. **Tarpey news** — search "Tarpey" Ireland

Where a bullet rests on a specific article, wrap a few words of it in an <a href="..."> link.

A section with no news is still included, with one bullet saying so. Never drop a section.

## 2 — Trending — one item
Find something with genuine grassroots momentum in Ireland right now: a local tech product or
startup, an indie musician going viral, a consumer phenomenon, a cultural movement. Authentic
Irish origin and organic momentum — NOT mainstream celebrities or government initiatives.
Good examples: an independent musician with a breakout song, a homegrown app gaining
unexpected traction, a regional food or fashion trend spreading nationally.

One or two searches. Collect: the name, the category (Music / Tech / Food / …), the city or
region of origin, the story of its rise — why it is resonating, who is behind it, how it
spread — and 1–2 source URLs.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Ireland Weekly Digest &mdash; The Daily Brief</title>
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
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; } li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  .trending-box { margin-top:24px; border-top:2px solid var(--line); padding-top:18px; }
  .trending-label { font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.8px; color:#e07b00; margin-bottom:6px; }
  .trending-title { font-size:16px; font-weight:700; color:var(--navy); margin-bottom:2px; }
  .trending-meta { font-size:12px; color:var(--muted); margin-bottom:10px; }
  p.trending-summary { font-size:14px; line-height:1.75; color:var(--ink); }
  p.trending-summary a { color:#1f5fae; font-weight:600; text-decoration:none; border-bottom:1px solid #c5d8f5; }
  p.trending-summary a:hover { border-bottom-color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="index.html">&larr; Back to dashboard</a>
<h1>Ireland Weekly Digest</h1>
<div class="sub">Latest: week of [Sat DD] to [Sat DD, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Ireland Weekly Digest</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week of [Sat DD] to [Sat DD, YYYY]</div>
[one <section> per topic, sections 1–10 in order: <h2>Topic</h2><ul>3–5 bullets</ul>]
<section>
  <div class="trending-box">
    <div class="trending-label">&#x1F525; Trending in Ireland</div>
    <div class="trending-title">[Name]</div>
    <div class="trending-meta">[Category] &middot; [City/Region]</div>
    <p class="trending-summary">[3–5 sentences, 1–2 inline source links]</p>
  </div>
</section>
</article>

## 5 — Merge
Keep prior editions dated 1–7 days before today.
