#!/usr/bin/env bash
# Creates jobs/ for tarpeyjr-netizen/tarpey-daily-brief.
# Run from the repo root, then commit and push.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/README.md <<'MARK_jobs_README_md'
# jobs/ — page specifications for The Daily Brief

Each `<page>.md` is the complete specification for one published page: its gate, research
method, HTML shell, edition structure and history depth. A routine reads `_publish.md` for the
shared clone/build/commit/push/verify sequence, then reads one spec per page it is building
today.

## Why the specs live here

Every page is specified in exactly one place. A page that publishes on five different days is
still one file, so changing its sources or format is one edit rather than five. The specs are
versioned alongside the pages they produce, and any Claude session with this repo selected can
read and edit them.

## Files

    _publish.md              shared clone / build / commit / push / verify block
    <page>.md                one per published page
    rosters/*.csv            data the specs read at run time

## Rosters

`rosters/` replaced four Google Sheets read through the Drive connector. Each spec now reads
its CSV out of the clone. There are no fallback tables and no "roster warning" banners — the
CSV is the single source of truth, and a missing or unreadable one is a failed page rather
than a silent fall back to stale data.

Edit a roster in the GitHub web UI (navigate to the file, pencil icon, commit), or ask Claude
in a session with this repo selected.

    rosters/countries.csv     day,country,population,continent      — world-news
    rosters/cities.csv        day,primary_city,secondary_city       — cities
    rosters/art-museums.csv   museum,city,country                   — art
    rosters/ai-tools.csv      tool,day_of_week                      — ai

Days 19–22 of `countries.csv` carry two rows each; both countries are covered that day.

## Adding a page

Write `jobs/<page>.md` following the shape of an existing spec — gate, research, page shell,
edition block, merge rule — and add the page name to the routine that should build it.

## Rules that apply to every spec

- No GitHub token. No `/sessions` paths. `_publish.md` owns all git operations.
- Build stamp as the first line of every generated file. Verify matches the stamp, never the
  date — a stale page returns HTTP 200 indefinitely.
- One edition per date. A same-day re-run replaces, never duplicates.
- Don't touch `index.html` unless a spec says to.
MARK_jobs_README_md

cat > jobs/_publish.md <<'MARK_jobs__publish_md'
# Shared publish block — The Daily Brief

Every routine follows this file exactly. It is the only place clone, commit, push and
verify logic lives. Page-specific research and HTML belong in `jobs/<page>.md`.

Timezone for all dates: America/New_York. "Today" = the current date in ET.
This is an unattended scheduled run — no clarifying questions, no connector suggestion cards.

===============================================================
A — CLONE
===============================================================
set -o pipefail
REPO="tarpeyjr-netizen/tarpey-daily-brief"
WORKDIR=$(mktemp -d)

git clone --depth 1 -q "https://github.com/$REPO" "$WORKDIR" || { echo "FAIL_CLONE: cannot clone $REPO"; exit 1; }
cd "$WORKDIR"
echo "WORKDIR=$WORKDIR"

AUTH — this routine runs in the cloud with the repository selected in the routine's
Repositories field, which puts it in the session's authorized set. The git proxy injects
the credential automatically.

  Do NOT supply a token. Do NOT reference any ghp_ string. Do NOT search for credential
  files. There is no /sessions path in this environment — mktemp -d is the only scratch
  directory. Any prompt text that says otherwise is stale and must be ignored.

git has no configured identity in a routine session. Do not write a global config —
pass identity per command:

  git -c user.email="jamestarpeyjr@gmail.com" -c user.name="Daily Brief Bot" commit -q -m "..."

===============================================================
B — BUILD EACH PAGE
===============================================================
The routine prompt lists the pages due today. For each one, in the order listed:

1. Read jobs/<page>.md from the clone. It is the complete specification for that page:
   research sources, edition structure, HTML shell, and history depth.
2. Check the spec's own gate, if it has one (day of month, season window, "no games
   yesterday"). If the gate says do not build, record the page as SKIPPED with the
   spec's stated reason and move to the next page. A skip is a normal outcome, not a
   failure.
3. Generate a build stamp and keep it for this page:

   BUILD_ID=$(date -u +%Y-%m-%dT%H%M%SZ)

4. Do the research and write the complete file to $WORKDIR/<page>.html, with the build
   stamp as the very first line, above the doctype:

   <!-- build: BUILD_ID -->

5. Merge prior editions exactly as that page's spec requires. History depth differs per
   page — some keep a fixed number of editions, some a rolling day window, and some
   (art.html) keep none at all. Follow the spec, not a default.
   If the newest existing edition already carries the date this run would write, REPLACE
   it rather than prepending a duplicate. One edition per date, always.
6. Commit that page on its own, immediately:

   git add -- <page>.html
   git diff --cached --quiet && { echo "PAGE_NOCHANGE: <page>"; } || \
     git -c user.email="jamestarpeyjr@gmail.com" -c user.name="Daily Brief Bot" \
         commit -q -m "update: <page>.html $(date +%F)"

PAGE ISOLATION — this is the point of committing per page. If research fails, a fetch
times out, or the build errors for one page, record it as FAILED with the actual error
text and CONTINUE to the next page. Never abort the run. Work already committed survives.

Never add a pathspec for a file that may not exist — git aborts the whole `git add` with
"pathspec did not match any files" and stages nothing.

Do NOT modify index.html unless a page's own spec explicitly instructs it.

===============================================================
C — PUSH ONCE
===============================================================
cd "$WORKDIR"
if git log origin/main..HEAD --oneline | grep -q .; then
  git push origin main 2>&1 || { echo "FAIL_PUSH: push rejected — is $REPO selected in this routine's Repositories field?"; exit 1; }
  echo "Pushed $(git log origin/main..HEAD --oneline | wc -l) commit(s) — head $(git log -1 --format=%h)"
else
  echo "NOTHING_TO_PUSH: every page skipped or unchanged"
fi

===============================================================
D — VERIFY EACH PUBLISHED PAGE
===============================================================
Verify only the pages actually committed this run. A matching date is NOT sufficient —
only a matching build stamp proves the new file is live. A stale page returns HTTP 200
indefinitely, which is how a silent failure hides.

sleep 45
for PAGE in <pages committed this run>; do
  STAMP=$(grep -m1 -o '<!-- build: [^ ]*' "$WORKDIR/$PAGE.html" | sed 's/.*build: //')
  LIVE=$(curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html")
  if echo "$LIVE" | grep -q "build: $STAMP"; then
    echo "VERIFY_OK: $PAGE"
  else
    sleep 30
    LIVE=$(curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html")
    echo "$LIVE" | grep -q "build: $STAMP" && echo "VERIFY_OK: $PAGE" || {
      echo "FAIL_VERIFY: $PAGE — live stamp: $(echo "$LIVE" | grep -o '<!-- build: [^>]*-->' | head -1)"
    }
  fi
done

If verify fails with 403 or "host_not_allowed", the routine's environment needs
tarpey-daily-brief.pages.dev in its custom network allowlist. The push travels through the
git proxy and is unaffected — in that case the publish SUCCEEDED and only the confirmation
failed. Report it as FAIL_VERIFY with the error text so the distinction stays visible.

===============================================================
E — FINAL RESPONSE
===============================================================
One line per page, then one summary line. Nothing else. No preamble, no commentary.

  <page>: published — <commit>
  <page>: skipped — <reason from the spec>
  <page>: failed — <FAIL marker and the actual error text>

  <N> published, <N> skipped, <N> failed — https://tarpey-daily-brief.pages.dev/

Never report a page as published unless its build stamp matched during verify.
If STEP C printed FAIL_PUSH, every page is failed regardless of what the live site shows.
MARK_jobs__publish_md

cat > jobs/world-news.md <<'MARK_jobs_world_news_md'
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
MARK_jobs_world_news_md

cat > jobs/cities.md <<'MARK_jobs_cities_md'
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
MARK_jobs_cities_md

cat > jobs/triangle-nc.md <<'MARK_jobs_triangle_nc_md'
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
MARK_jobs_triangle_nc_md

cat > jobs/art.md <<'MARK_jobs_art_md'
# art.html — Daily Art

Cadence: every day. History: NONE — this page is replaced wholesale each run, single artwork,
no <article class="edition"> blocks and no merge step.
Roster: jobs/rosters/art-museums.csv (museum,city,country)

## Gate
None. Runs every day.

## 1 — Pick today's museum
Read jobs/rosters/art-museums.csv from the clone. Pick deterministically for today:

python3 -c "import random,datetime,csv; rows=list(csv.DictReader(open('jobs/rosters/art-museums.csv'))); random.seed(datetime.date.today().toordinal()); m=random.choice(rows); print(m['museum'],'|',m['city'],'|',m['country'])"

No fallback list, no warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Find today's artwork
One painting or photograph with a publicly accessible image.

Metropolitan Museum of Art:
1. GET https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isPublicDomain=true&medium=Paintings&q=painting — take a random objectID from the first 300
2. GET https://collectionapi.metmuseum.org/public/collection/v1/objects/{id} — use primaryImage.
   Collect title, artistDisplayName, classification, objectDate, department, medium, accessionYear, creditLine.

Art Institute of Chicago:
1. GET https://api.artic.edu/api/v1/artworks?page={random 1-60}&limit=20&fields=id,title,artist_display,date_display,image_id,classification_title,style_title,short_description&query[bool][must][0][term][is_public_domain]=true&query[bool][must][1][term][artwork_type_title]=Painting
2. Any result with an image_id. Image URL: https://www.artic.edu/iiif/2/{image_id}/full/843,/0/default.jpg

All other museums:
1. Pick a subject/style for today:
   python3 -c "import random,datetime; s=['portrait','landscape','still life','religious scene','mythological scene','genre scene','allegorical','historical','interior','nude figure','animal','seascape','cityscape','battle scene']; random.seed(datetime.date.today().toordinal()+99); print(random.choice(s))"
2. Check what is already on the page to avoid a repeat — the cloned art.html is right there:
   grep -o '<h2>[^<]*</h2>' art.html
   Do not pick that same work again.
3. Search Wikipedia: "{museum name}" {style} painting. Pick ANY work from the results — do NOT
   default to the single most famous work at that museum (not Mona Lisa for the Louvre, not
   The Founding Ceremony of the Nation for the National Museum of China). Variety is the goal.
4. The work must have a Wikimedia Commons image (https://upload.wikimedia.org/...). Verify the
   URL ends in .jpg or .png. If none, try a different style from the list.

## 3 — Fields to collect
Title (full) · Artist (name and dates if known) · Style (movement or classification) ·
Year (date or range) · Museum (full name with city/country from the CSV) · Image URL ·
Interesting Fact (2–3 engaging sentences: a surprising story, a historical controversy, an
unusual detail — not generic filler).

## 4 — Page shell
Build stamp first line, above the doctype. Long date via `date +"%A, %B %-d, %Y"`.
Substitute every {PLACEHOLDER}. This page has no edition history — write it complete each run.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="noindex, nofollow">
  <title>Daily Art — The Daily Brief</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: #0f0f0f; color: #f0ede8; font-family: 'Georgia', 'Times New Roman', serif; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
    header { width: 100%; padding: 28px 32px 20px; text-align: center; border-bottom: 1px solid #222; }
    .header-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #777; margin-bottom: 6px; }
    header h1 { font-size: clamp(22px, 4vw, 34px); font-weight: normal; letter-spacing: 0.02em; }
    .header-date { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 12px; color: #555; margin-top: 8px; letter-spacing: 1px; }
    .back { display: inline-block; font-size: 13px; color: #555; text-decoration: none; margin-top: 10px; }
    .back:hover { color: #999; }
    main { max-width: 880px; width: 100%; padding: 52px 24px 64px; }
    .artwork-frame { text-align: center; margin-bottom: 44px; }
    .artwork-frame img { max-width: 100%; max-height: 74vh; object-fit: contain; border: 1px solid #2a2a2a; box-shadow: 0 0 0 8px #141414, 0 0 0 9px #272727, 0 32px 90px rgba(0,0,0,0.8); display: block; margin: 0 auto; }
    .meta h2 { font-size: clamp(22px, 3.5vw, 30px); font-weight: normal; line-height: 1.25; margin-bottom: 16px; }
    .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 18px 28px; border-top: 1px solid #1e1e1e; padding-top: 20px; margin-bottom: 32px; }
    .meta-item { display: flex; flex-direction: column; gap: 5px; }
    .meta-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #5a5a5a; }
    .meta-value { font-size: 15px; color: #ccc9c2; line-height: 1.4; }
    .fact-block { background: #141414; border-left: 2px solid #3a3a3a; border-radius: 2px; padding: 20px 24px; }
    .fact-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 10px; }
    .fact-block p { font-size: 16px; line-height: 1.78; color: #b0aca6; }
    footer { margin-top: auto; padding: 28px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; color: #333; letter-spacing: 1px; text-align: center; }
  </style>
</head>
<body>
<header>
  <div class="header-label">Tarpey Daily Brief</div>
  <h1>Daily Art</h1>
  <div class="header-date">{TODAY_LONG_DATE}</div>
  <a class="back" href="index.html">&larr; Back to dashboard</a>
</header>
<main>
  <div class="artwork-frame">
    <img src="{IMAGE_URL}" alt="{TITLE}" onerror="this.style.opacity=0.3">
  </div>
  <div class="meta">
    <h2>{TITLE}</h2>
    <div class="meta-grid">
      <div class="meta-item"><span class="meta-label">Artist</span><span class="meta-value">{ARTIST}</span></div>
      <div class="meta-item"><span class="meta-label">Style</span><span class="meta-value">{STYLE}</span></div>
      <div class="meta-item"><span class="meta-label">Year</span><span class="meta-value">{YEAR}</span></div>
      <div class="meta-item"><span class="meta-label">Museum</span><span class="meta-value">{MUSEUM}</span></div>
    </div>
    <div class="fact-block">
      <div class="fact-label">Interesting Fact</div>
      <p>{FACT}</p>
    </div>
  </div>
</main>
<footer>Updated daily &middot; Tarpey Daily Brief</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>
MARK_jobs_art_md

cat > jobs/ai.md <<'MARK_jobs_ai_md'
# ai.html — AI Developments

Cadence: every day. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/ai-tools.csv (tool,day_of_week) — two tools per day.

## Gate
None. Runs every day.

## 1 — Today's tools
Read jobs/rosters/ai-tools.csv from the clone and select every row whose day_of_week matches
today's weekday name. No fallback schedule, no roster warning banner. A missing or unreadable
CSV is a FAILED page.

## 2 — Writing style — STRICTLY ENFORCED
Each tool section is a flowing "This Week in [Tool]" magazine article — 3–4 paragraphs of
connected prose, no bullet points. Tone: a smart, enthusiastic journalist writing for a curious
15-year-old. Conversational, plain English, short sentences, real-world analogies, zero
corporate speak. Paragraphs flow into each other. Cover the 3–5 most significant developments
woven into a narrative, not listed separately. If it was a quiet week, say so warmly in a short
paragraph and note the last interesting thing that happened.

## 3 — Research
Cutoff: python3 -c "import datetime; print((datetime.date.today()-datetime.timedelta(days=7)).strftime('%Y-%m-%d'))"

Two searches per tool:
1. "[Tool] news update announcement after:CUTOFF"
2. "[Tool] new features release after:CUTOFF"

Take the 3–5 most interesting developments per tool from the past 7 days. If genuinely nothing
in 7 days, broaden to 14 and note it was a quiet week.

## 4 — Tool Spotlight — Wednesdays and Saturdays only
After the scheduled tools, pick ONE AI tool, product or model that is NOT in ai-tools.csv, has
had a notable release or moment in the last 2 weeks, and is genuinely interesting. Search
"new AI tool announcement [current week]" or "AI model release [current month year]".
Write 150–200 words of prose: what it is, what it does, why it matters, who would use it, and
anything surprising. Title the section "🔍 Tool Spotlight: [Tool Name]".

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>AI Developments &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --ai-accent:#7c3aed; }
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
  .tool-chip { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; padding:3px 10px; border-radius:20px; margin-bottom:12px; background:#ede9fe; color:#5b21b6; }
  .spotlight-chip { background:#fef3c7; color:#92400e; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  section.spotlight { border-left:4px solid var(--ai-accent); }
  h2 { font-size:18px; color:var(--navy); margin-bottom:10px; }
  p { font-size:14.5px; line-height:1.75; margin-bottom:12px; }
  p:last-child { margin-bottom:0; }
  .quiet { font-style:italic; color:var(--muted); font-size:13px; }
  .muted { color:var(--muted); font-size:13px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>AI Developments</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; tools &middot; releases &middot; breakthroughs &middot; what it means for you</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; AI Developments &middot; Updated daily at 4 AM</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 6 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">AI Developments &mdash; [Day of Week], [Month D, YYYY]</div>
[one section per tool scheduled today:]
<section>
<span class="tool-chip">[Tool]</span>
<h2>This Week in [Tool]</h2>
<p>[Opening: 1–2 sentences of plain-English context on what the tool is, flowing straight into the week's news.]</p>
<p>[Middle: the week's 3–5 developments woven into connected prose — what happened, why it matters, what it feels like in practice.]</p>
<p>[Closing: a brief forward-looking "so what".]</p>
[quiet week instead: <p class="quiet">Quiet week for [Tool] — no major announcements in the past seven days. The last notable move was [brief note].</p>]
</section>
[Wednesdays and Saturdays only:]
<section class="spotlight">
<span class="tool-chip spotlight-chip">🔍 Tool Spotlight</span>
<h2>[Tool Name]</h2>
<p>[150–200 words of flowing prose, no bullets, teen-friendly.]</p>
<p class="muted">Source: [Source Name, Month YYYY]</p>
</section>
</article>

## 7 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_ai_md

cat > jobs/science.md <<'MARK_jobs_science_md'
# science.html — Science Daily

Cadence: every day. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: none — the topic rotation is below.

## Gate
None. Runs every day.

## 1 — Today's topic
date +"%A"; python3 -c "import datetime; wk=datetime.date.today().isocalendar()[1]; print('WEEK_1' if wk%2==1 else 'WEEK_2')"

Odd ISO week = WEEK_1. Even ISO week = WEEK_2. This alternates automatically — never hardcode.

WEEK_1: Mon Space · Tue Physics · Wed Chemistry · Thu Biology · Fri Medicine · Sat Agriculture
WEEK_2: Mon Batteries & Electricity · Tue Oceanography · Wed Robotics & Engineering ·
        Thu Mathematics · Fri Epidemiology · Sat Neuroscience
Sunday (both weeks): LONG READ — different format, see section 3.

## 2 — Monday–Saturday
Cutoff: python3 -c "import datetime; print((datetime.date.today()-datetime.timedelta(days=7)).strftime('%Y-%m-%d'))"

2–3 searches on today's topic:
1. "[topic] discovery breakthrough research after:CUTOFF"
2. "[topic] study announcement [current month year]"
3. "new [topic] research news this week"

Take the 4–6 most interesting, significant or surprising developments from the past 7 days —
peer-reviewed studies, major discoveries, notable missions/trials/reports. Prefer primary
science journalism over press releases. If genuinely nothing in 7 days, broaden to 14 and note
it was a quiet week.

Write 3–4 connected paragraphs: an opening that frames what is interesting in the field and
flows into this week's news; a middle weaving the developments together with analogies; a
closing "so what" for a curious non-scientist.

## 3 — Sunday long read
Replaces the roundup format entirely, every Sunday, regardless of WEEK_1/WEEK_2.

Pick a category NOT among the twelve in the Mon–Sat rotations:

python3 -c "
import random, datetime
topics = ['Genetics & Genomics','Paleontology','Geology','Climate Science','Astrobiology','Quantum Computing','Materials Science','Cognitive Science & Psychology','Volcanology','Entomology','Immunology','Meteorology','Anthropology','Marine Biology','Nanotechnology','Sleep Science','Seismology','Evolutionary Biology','Exoplanets','Botany','Zoology','Microbiology','Renewable Energy Science','Cryobiology','Linguistics & the Science of Language']
random.seed(datetime.date.today().toordinal())
print(random.choice(topics))
"

Check the cloned science.html for recent repeats — the file is already in the clone:
  grep -o '<h2 class="longread-title">[^<]*</h2>' science.html
If today's pick clearly overlaps a headline from the last 4 editions, re-roll with a seed
offset (+1, +2, …) until it is fresh.

Within that category, 3–5 searches to find ONE specific compelling story, discovery,
phenomenon or open mystery — not a generic overview. Good: a single wild experiment, a strange
organism, an unsolved puzzle, a landmark discovery and its human story.

Write 600–900 words with a real narrative arc: hook, context, the science explained
accessibly, why it matters or what is still unknown, a memorable closing thought. No bullets,
no headers inside the prose. Same accessible plain-English voice as the daily sections.

## 4 — Writing style — STRICTLY ENFORCED
Flowing magazine prose. No bullet points, no listicles. A smart, curious science journalist
writing for an intelligent general reader who is not a specialist: plain-English explanations
of jargon, real-world analogies, genuine enthusiasm, zero corporate or press-release speak.
Weave developments into a narrative rather than listing them. If the week was quiet, say so
warmly and note the last genuinely interesting thing in that field.

## 5 — Topic chip colors (background / text)
Space #e0e7ff/#4338ca · Physics #dbeafe/#1d4ed8 · Chemistry #d1fae5/#047857 ·
Biology #ccfbf1/#0f766e · Medicine #fee2e2/#b91c1c · Agriculture #fef3c7/#92400e ·
Batteries & Electricity #fef9c3/#854d0e · Oceanography #cffafe/#0e7490 ·
Robotics & Engineering #e2e8f0/#334155 · Mathematics #fae8ff/#86198f ·
Epidemiology #ffe4e6/#9f1239 · Neuroscience #e9d5ff/#7e22ce · Sunday long read #ede9fe/#6d28d9

## 6 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Science Daily &mdash; The Daily Brief</title>
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
  .topic-chip { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; padding:3px 10px; border-radius:20px; margin-bottom:12px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  section.longread { border-left:4px solid #6d28d9; }
  h2 { font-size:18px; color:var(--navy); margin-bottom:10px; }
  h2.longread-title { font-size:21px; }
  p { font-size:14.5px; line-height:1.75; margin-bottom:12px; }
  p:last-child { margin-bottom:0; }
  .quiet { font-style:italic; color:var(--muted); font-size:13px; }
  .muted { color:var(--muted); font-size:13px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Science Daily</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; alternating weekly topics &middot; Sunday long read</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Science Daily &middot; Updated daily</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 7 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Science Daily &mdash; [Day of Week], [Month D, YYYY]</div>
[Mon–Sat:]
<section>
<span class="topic-chip" style="background:[BG];color:[TEXT]">[Topic]</span>
<h2>This Week in [Topic]</h2>
<p>[Opening]</p><p>[Middle]</p><p>[Closing "so what"]</p>
[quiet week: <p class="quiet">Quiet week for [Topic] — no major developments in the past seven days. The last notable finding was [brief note].</p>]
</section>
[Sunday instead:]
<section class="longread">
<span class="topic-chip" style="background:#ede9fe;color:#6d28d9">Sunday Long Read</span>
<h2 class="longread-title">[Feature Title]</h2>
<p class="muted">[Category]</p>
<p>[600–900 words in natural paragraphs]</p>
</section>
</article>

## 8 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_science_md

cat > jobs/mlb-game-of-the-day.md <<'MARK_jobs_mlb_game_of_the_day_md'
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
MARK_jobs_mlb_game_of_the_day_md

cat > jobs/college-football.md <<'MARK_jobs_college_football_md'
# college-football.html — College Football Tracker

Cadence: every day in season, Mondays only in the off-season. History: today + up to 6 prior
editions (7 total). Roster: none — tracked teams are below.

## Gate
IN-SEASON = today is between Aug 20 and the CFP National Championship (mid-January), inclusive.
Build every day.
OFF-SEASON = any other date. Build on Mondays only. If it is the off-season and today is NOT a
Monday, SKIP with the reason "Off-season, non-Monday". A skip is a normal outcome.

In off-season Monday editions the content pivots to recruiting, the transfer portal, the
coaching carousel, signing day and spring practice. Same three-section structure, but Secondary
Teams becomes a short "portal & recruiting notes" list instead of a schedule table, and Top 25
becomes national off-season news. Label the edition header "Off-season weekly".

## 1 — Tracked teams
PRIMARY — news every single day:
- Texas A&M Aggies (FBS, SEC)
- Penn State Nittany Lions (FBS, Big Ten)
- Villanova Wildcats (FCS, Patriot League — first year in the league as of 2026)

SECONDARY — next game date always; preview the day before a game, review the day after:
- Texas Tech Red Raiders · Minnesota Golden Gophers · Georgia Tech Yellow Jackets
- Miami Hurricanes · Duke Blue Devils · North Carolina Tar Heels · Florida Gators
- College of Wooster Fighting Scots (NCAA Division III, North Coast Athletic Conference —
  coverage is thin; use woosterathletics.com, northcoast.org and d3football.com; a schedule
  line and box score is fine)

## 2 — Research
Endpoints (WebFetch handles these ESPN JSON APIs well; the www.espn.com HTML pages return empty):
- AP Top 25: https://site.api.espn.com/apis/site/v2/sports/football/college-football/rankings
- Scoreboard: https://site.api.espn.com/apis/site/v2/sports/football/college-football/scoreboard?dates=YYYYMMDD&groups=80&limit=200  (drop groups=80 to include FCS)
- Team schedule: https://site.api.espn.com/apis/site/v2/sports/football/college-football/teams/{id}/schedule?season={YYYY}&seasontype=2
- Team news: https://site.api.espn.com/apis/site/v2/sports/football/college-football/news?team={id}&limit=15

ESPN team IDs: Texas A&M 245 · Penn State 213 · Villanova 222 · Texas Tech 2641 · Minnesota 135 ·
Georgia Tech 59 · Miami 2390 · Duke 150 · North Carolina 153 · Florida 57 · Wooster 2748.

DATE HANDLING: the ESPN JSON date field is UTC (2026-09-04T00:00Z is Thursday Sep 3, 8:00 p.m.
ET). Always convert to ET before writing a day-of-week or kickoff time — do not trust a
summarizer's rendering of the date.

### A. Primary teams — every day
3–6 news items per team from the last 48 hours: injuries, depth chart, coaching, recruiting,
honors, program news. One bullet each, ending with source attribution in parentheses, e.g.
(12thMan.com, Aug. 24). Sources: school athletics sites (12thman.com, gopsusports.com,
villanova.com), StateCollege.com, Philadelphia Inquirer, SI/On3/247Sports team sites,
Yardbarker, local beat outlets. The team news-index pages carry dated headlines and fetch
reliably: https://12thman.com/sports/football/news, https://gopsusports.com/sports/football/news

Game-day segments for primary teams:
- Day before a game — add <h4>Pre-Game: [Opponent]</h4>: opponent record and ranking, kickoff
  time/TV/venue, betting line if available, 3–5 key matchups or storylines, injury report, and
  what a win or loss means. Add <span class="tag tag-preview">Pre-Game</span> to the team's <h3>.
- Day after a game — add <h4>Review: [Final score]</h4>: final score, how the game turned, top
  performers with stat lines, turning point, what it means for the record/rankings, what's next.
  Add <span class="tag tag-gameday">Review</span> to the team's <h3>.
- Both can appear the same day if a team played yesterday and plays tomorrow.

### B. Secondary teams
Always a schedule table with each team's next game: opponent, date, kickoff time ET, TV,
home/away, sorted soonest first. Add AP ranking in the team cell when ranked.
Then, only for secondary teams with a game yesterday or tomorrow:
- Tomorrow → 2–4 sentence preview under an <h3>: records, line, main storyline, key players.
- Yesterday → 2–4 sentence review: final score, top performers, how it happened, record after.
If none apply, keep just the table plus one line noting the next matchup on the calendar.

### C. Top 25 scoreboard
Pull yesterday's scoreboard. Report the final score of every game involving an AP Top 25 team,
excluding games already covered above. Render as a table: matchup (with rankings), final score,
and a note column (upset, overtime, ranked-vs-ranked, blowout). Mark an unranked team beating a
ranked team with <strong>UPSET</strong>.
If no ranked teams played yesterday, say so in one sentence and list upcoming ranked-team games
for the next 7 days with dates, times, TV. Close with a one-line note of the current AP ranking
of any tracked team that is ranked.

## 3 — One-time repo cleanup
An early run wrote a double-extension file that Cloudflare Pages served at /college-football.html,
masking failed publishes. Guarded — a no-op once the file is gone:

if git ls-files --error-unmatch college-football.html.html >/dev/null 2>&1; then
  git rm -q college-football.html.html && echo "removed stray duplicate"
fi

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>College Football Tracker &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --accent:#8a1d2c; }
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
  h3 { font-size:15px; margin:16px 0 4px; }
  h3:first-of-type { margin-top:4px; }
  h4 { font-size:14px; color:var(--accent); margin:14px 0 6px; text-transform:uppercase; letter-spacing:.4px; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; } li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .muted { color:var(--muted); font-size:13px; }
  .tag { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; padding:2px 7px; border-radius:4px; vertical-align:middle; margin-left:6px; }
  .tag-primary { background:#1f3a5f; color:#fff; }
  .tag-gameday { background:var(--accent); color:#fff; }
  .tag-preview { background:#e8edf5; color:var(--navy); }
  .nextgame { font-size:13px; color:var(--muted); border-left:3px solid var(--line); padding-left:10px; margin:4px 0 8px; }
  table { width:100%; border-collapse:collapse; margin-top:8px; font-size:13.5px; }
  th { text-align:left; font-size:11.5px; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); border-bottom:1px solid var(--line); padding:6px 8px 6px 0; }
  td { padding:7px 8px 7px 0; border-bottom:1px solid var(--line); line-height:1.45; }
  .tbl-wrap { overflow-x:auto; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>College Football Tracker</h1>
<div class="sub">Latest: [LONG DATE] &middot; Primary teams daily &middot; Secondary teams around game days &middot; Top 25 scoreboard</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[UP TO 6 PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; College Football Tracker &middot; updated daily at 5:00 a.m. ET</footer>
<script>document.querySelectorAll('main a[href^="http"]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="YYYY-MM-DD">
<div class="ed-head">Edition for [Weekday], [Month] [D], [YYYY] &middot; [Week N of the 2026 season | Bowl season | Off-season weekly]</div>
<section>
<h2>Primary Teams</h2>
<h3>[Team] <span class="tag tag-primary">[AP rank or conference]</span></h3>
<div class="nextgame">Next: [Day, Month D] [vs./at] [Opponent] &middot; [time ET] &middot; [TV] &middot; [venue]</div>
<ul><li>[news item] ([Source], [date])</li></ul>
</section>
<section>
<h2>Secondary Teams</h2>
<p class="muted">Next game dates below. A full preview runs the day before each game and a review the day after.</p>
<div class="tbl-wrap"><table>
<thead><tr><th>Team</th><th>Next Game</th><th>Date &amp; Time (ET)</th><th>TV</th></tr></thead>
<tbody><tr><td><strong>[Team]</strong></td><td>[vs./at Opponent]</td><td>[Day, Mon D] &middot; [time]</td><td>[TV]</td></tr></tbody>
</table></div>
</section>
<section>
<h2>Top 25 Scoreboard</h2>
<div class="tbl-wrap"><table>
<thead><tr><th>Matchup</th><th>Final</th><th>Note</th></tr></thead>
<tbody><tr><td>[No. X Team] at [No. Y Team]</td><td>[24-17]</td><td>[note]</td></tr></tbody>
</table></div>
<p class="muted">[AP ranking line for tracked teams.]</p>
</section>
</article>

## 6 — index.html — EXCEPTION
This spec is permitted to touch index.html. Check the dashboard card exists:

  grep -q "href='/college-football'" index.html || echo "CARD_MISSING"

If CARD_MISSING, insert this line immediately before the line containing href='/sports',
preserving indentation, and stage index.html alongside college-football.html:

      <a class='card' href='/college-football'><h2>College Football Tracker</h2><div class="desc">Daily news on Texas A&amp;M, Penn State &amp; Villanova with extended coverage around game days, next-game dates and previews/reviews for 8 secondary teams, plus a Top 25 scoreboard.</div><div class="meta">Updated daily at 5:00 AM</div></a>
MARK_jobs_college_football_md

cat > jobs/rosters/countries.csv <<'MARK_jobs_rosters_countries_csv'
day,country,population,continent
1,Canada,~38M,North America
2,Argentina,~46M,South America
3,United Kingdom,~68M,Europe
4,China,~1.41B,Asia
5,Egypt,~106M,Africa
6,Venezuela,~29M,South America
7,Spain,~48M,Europe
8,Mexico,~130M,North America
9,India,~1.44B,Asia
10,Brazil,~215M,South America
11,Finland,~6M,Europe
12,Israel,~7M,Asia
13,Kenya,~56M,Africa
14,Iran,~90M,Asia
15,Panama,~4M,North America
16,Japan,~124M,Asia
17,France,~68M,Europe
18,Vietnam,~98M,Asia
19,Nigeria,~225M,Africa
19,South Africa,~61M,Africa
20,Ukraine,~44M (pre-war estimate),Europe
20,Turkey,~86M,Asia
21,Saudi Arabia,~37M,Asia
21,Russia,~144M (transcontinental; European portion listed here),Europe
22,Cuba,~12M,North America
22,Uzbekistan,~36M,Asia
23,Colombia,~52M,South America
24,Chile,~19M,South America
25,Ethiopia,~128M,Africa
26,Iraq,~43M,Asia
27,Germany,~84M,Europe
28,South Korea,~52M,Asia
29,Australia,~26M,Oceania
30,Peru,~33M,South America
31,Iceland,~0.37M,Europe
MARK_jobs_rosters_countries_csv

cat > jobs/rosters/cities.csv <<'MARK_jobs_rosters_cities_csv'
day,primary_city,secondary_city
1,"New York, NY","Philadelphia, PA"
2,"Los Angeles, CA","Fargo, ND"
3,"Chicago, IL","Boise, ID"
4,"Dallas, TX","Boulder, CO"
5,"Houston, TX","Wilmington, DE"
6,"Washington, DC","Clearwater, FL"
7,"Atlanta, GA","Savannah, GA"
8,"Miami-Fort Lauderdale, FL","Charleston, SC"
9,"Philadelphia, PA","Wilmington, NC"
10,"Phoenix-Mesa, AZ","Sunset Beach, NC"
11,"Cleveland, OH","Columbia, SC"
12,"Seattle, WA","Fayetteville, AR"
13,"San Francisco-Oakland, CA","Juneau, AK"
14,"Detroit, MI","Honolulu, HI"
15,"Minneapolis-St. Paul, MN","Billings, MT"
16,"San Diego, CA","Philadelphia, PA"
17,"Tampa-St. Petersburg, FL","New Orleans, LA"
18,"Denver, CO","Salt Lake City, UT"
19,"Orlando, FL","Phoenixville, PA"
20,"Charlotte, NC","Malvern, PA"
21,"Baltimore, MD","Wooster, OH"
22,"St. Louis, MO","Jackson, MS"
23,"Boston, MA","Oklahoma City, OK"
24,"Nashville, TN","Portland, OR"
25,"Indianapolis, IN","Philadelphia, PA"
26,"San Antonio, TX","Memphis, TN"
27,"Richmond, VA","Las Vegas, NV"
28,"Austin, TX","Long Beach Island, NJ"
29,"Pittsburgh, PA","Ocean City, MD"
30,"Columbus, OH","Boone, NC"
31,"Jacksonville, FL","Artesia, NM"
MARK_jobs_rosters_cities_csv

cat > jobs/rosters/art-museums.csv <<'MARK_jobs_rosters_art_museums_csv'
museum,city,country
British Museum,London,UK
State Hermitage Museum,St. Petersburg,Russia
Metropolitan Museum of Art,New York,USA
National Museum of China,Beijing,China
Louvre Museum,Paris,France
Art Institute of Chicago,Chicago,USA
National Palace Museum,Taipei,Taiwan
São Paulo Museum of Art (MASP),São Paulo,Brazil
National Gallery of Australia,Canberra,Australia
Zeitz Museum of Contemporary Art Africa (MOCAA),Cape Town,South Africa
National Museum of Modern Art,Tokyo,Japan
Philadelphia Museum of Art,Philadelphia,USA
MARK_jobs_rosters_art_museums_csv

cat > jobs/rosters/ai-tools.csv <<'MARK_jobs_rosters_ai_tools_csv'
tool,day_of_week
Google Gemini,Monday
Meta Llama,Monday
Anthropic Claude,Tuesday
Perplexity AI,Tuesday
Anthropic Claude CoWork,Wednesday
Eleven Labs,Wednesday
Anthropic Claude Code,Thursday
Xai Grok,Thursday
ChatGPT,Friday
Mistral AI,Friday
SAPJoule,Saturday
Einstein AI,Saturday
Microsoft Copilot,Sunday
Artlist,Sunday
MARK_jobs_rosters_ai_tools_csv

echo "Created:"
find jobs -type f | sort
