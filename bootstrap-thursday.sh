#!/usr/bin/env bash
# Adds the Thursday page specs and rosters to jobs/.
# jobs/sports.md is shared with the Monday routine.
# Run from the repo root, then commit and push to main.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/enterprise.md <<'MARK_jobs_enterprise_md'
# enterprise.html — Enterprise Software Intel

Cadence: Thursdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: none — the platform list is below.

## Gate
None. Runs every Thursday.

## Monthly supplement
Include the two Monthly Supplement sections ONLY on the first Thursday of the month:

  python3 -c "import datetime; d=datetime.date.today(); print(d.weekday()==3 and d.day<=7)"

Note: this page previously ran on Fridays and the supplement was keyed to the first Friday.
It now runs Thursdays and the gate is keyed to the first Thursday. Do not reintroduce a Friday
check — on a Thursday routine it would never fire.

## 1 — Research
WebSearch each section, in parallel where possible. Prioritize results from the past 7 days.
Keep the whole digest under about 1,400 words.

### Platform News — each platform gets its own <h3>
SAP sub-products, covered individually (search each by name + "2026"):
- **S/4HANA** — core ERP, cloud vs on-prem, migrations, the 2027 ECC deadline
- **Joule** — agents, Joule Studio, Joule Work
- **SAP Analytics Cloud** — BI, planning, predictive
- **SAP Integration Suite** — middleware, APIs, MCP/event mesh
- **SAP Build** — Build Apps, Build Work Zone, Build Process Automation (low-code)
- **WalkMe** — digital adoption, quarterly release
- **Signavio** — process intelligence, process mining
- **LeanIX** — enterprise architecture management, IT portfolio management, application
  rationalization, tech landscape mapping, cloud transformation planning
- **BTP** — Business Technology Platform, Business AI Platform
- **IBP** — Integrated Business Planning, supply chain
- **BRIM** — Billing & Revenue Innovation Management
- **Cloud ALM** — application lifecycle management

Where a sub-product has no news, note what to watch and where to monitor rather than padding.

Then one substantive paragraph each: **Salesforce**, **ServiceNow**, **Workday**,
**Microsoft 365**, **Databricks** (Data Intelligence Platform, Unity Catalog, Mosaic AI,
LakeFlow, and any enterprise data/AI announcements).

### AI in the Enterprise
Notable enterprise AI deployments and product updates (Copilot, Einstein, Now Assist, Joule),
plus one honest hype-vs-reality take. Search "enterprise AI deployment 2026" and
"enterprise AI product update 2026".

### Implementation Wins & Losses
Go-lives, case studies, failed rollouts, cost overruns. Name companies and systems. Search
"ERP implementation failure 2026", "Salesforce go-live 2026", "SAP go-live 2026".

### Threats & Risks
Security incidents on enterprise platforms, vendor lock-in stories, market shifts,
consolidation. Search "enterprise software security incident 2026", "vendor lock-in 2026".

### YouTube Picks
2–3 recent videos from enterprise channels (SAP Learning, Salesforce Developers, ServiceNow
Community, Workday, Microsoft Mechanics, Gartner). Title, channel, URL, and one sentence on
why it is worth watching.

### Training & Certification Finds
New courses, free resources, exam changes, new or retiring certs across SAP, Salesforce,
ServiceNow, Workday, Microsoft.

### Monthly supplement sections — first Thursday only
**Analyst Trend Roundup** — Gartner, Forrester, IDC reports or predictions published this
month. **Certification Landscape** — new certs launched, retiring certs, exam format changes
across all major platforms.

## 2 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Enterprise Software Intel &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --monthly-bg:#eef3fb; }
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
  section.monthly { background:var(--monthly-bg); border-color:#c3d4ed; }
  .monthly-rule { border:none; border-top:2px solid var(--navy); margin:8px 0 20px; opacity:.25; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; color:var(--ink); margin:14px 0 4px; }
  h3:first-child { margin-top:0; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  .monthly-label { display:inline-block; font-size:11px; font-weight:700; letter-spacing:.4px; text-transform:uppercase; background:var(--navy); color:#fff; border-radius:4px; padding:2px 7px; margin-bottom:12px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Enterprise Software Intel</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Enterprise Software Intel</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 3 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Enterprise Software Intel &mdash; Week of [Month D, YYYY]</div>
<section>
<h2>🏢 Platform News</h2>
[SAP sub-product <h3> blocks in the order listed above, each with <p> and inline source links]
[then <h3>Salesforce</h3>, <h3>ServiceNow</h3>, <h3>Workday</h3>, <h3>Microsoft 365</h3>, <h3>Databricks</h3>]
</section>
<section><h2>🤖 AI in the Enterprise</h2>[3–5 <li> bullets with source links]</section>
<section><h2>✅ Implementation Wins &amp; Losses</h2>[3–5 <li> bullets, company/system names bold]</section>
<section><h2>⚠️ Threats &amp; Risks</h2>[3–5 <li> bullets with source links]</section>
<section><h2>▶️ YouTube Picks</h2>[2–3 items: <h3><a href="[URL]">[Title]</a></h3><p><strong>[Channel]</strong> — [one sentence]</p>]</section>
<section><h2>🎓 Training &amp; Certification Finds</h2>[3–5 <li> bullets with links]</section>
[first Thursday of the month only:]
<hr class="monthly-rule">
<section class="monthly"><span class="monthly-label">Monthly Supplement</span><h2>📊 Analyst Trend Roundup</h2>[3–5 <li> bullets]</section>
<section class="monthly"><span class="monthly-label">Monthly Supplement</span><h2>📜 Certification Landscape</h2>[3–5 <li> bullets]</section>
</article>

## 4 — Merge
Keep prior editions dated 1–7 days before today.
MARK_jobs_enterprise_md

cat > jobs/sports.md <<'MARK_jobs_sports_md'
# sports.html — Sports News Digest

Cadence: Mondays AND Thursdays — the two days cover different team sets, see the run rules
below. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/sports-teams.csv (team,max_articles,group,season)

This spec is read by both the Monday and the Thursday routine. It is the same page and the
same file; only the day changes which teams qualify.

## Gate
None at the page level. The run rules below decide per team.

## 1 — Content rules, strictly enforced
INCLUDE only: injury and health updates, trades, free agency and signings, contract news,
roster moves, strategy/scheme/coaching news, player profile features.

EXCLUDE: game recaps, box scores, score summaries, game previews, standings updates. If an
article is primarily about a game result, skip it even when it mentions an injury in passing.

Prefer sources not behind a paywall. For the four Philadelphia teams (Phillies, Eagles,
Flyers, 76ers), nbcsportsphiladelphia.com is preferred — run a site: search against it for
each of those four in addition to the general search.

## 2 — Teams and run rules
Read jobs/rosters/sports-teams.csv from the clone. No fallback list and no warning banner.
A missing or unreadable CSV is a FAILED page.

Determine the day and each team's season state:

python3 -c "
import datetime
t=datetime.date.today(); dow=t.weekday()
print('monday' if dow==0 else 'thursday' if dow==3 else 'other',
      'first_monday' if (dow==0 and t.day<=7) else '')
"

The season column is a 'Mon-Mon' month range. A range where the start month is later than the
end month wraps the year (Sep-Jun, Aug-Feb): in season when the current month is >= start OR
<= end. Otherwise in season when start <= month <= end. If a season string cannot be parsed,
treat the team as in season.

| Team state | Monday | Thursday |
|---|---|---|
| In season, Primary or Secondary | run | run |
| In season, Tertiary | run | skip |
| Out of season, Primary or Secondary | run | skip |
| Out of season, Tertiary | run only on the first Monday of the month | skip |

A team skipped by these rules is not searched and does not appear in the digest at all — not
even in the "No news this period" section. That section lists only teams that WERE searched
today and returned nothing.

## 3 — Research
Cutoff — the past 10 days:
  python3 -c "import datetime; print((datetime.date.today()-datetime.timedelta(days=10)).strftime('%Y-%m-%d'))"

Searches per qualifying team: Primary 2 · Secondary 1–2 · Tertiary 1.

Query patterns (substitute the computed cutoff):
- "[Team] injury trade signing roster news after:CUTOFF"
- Philadelphia teams additionally: site:nbcsportsphiladelphia.com "[Team] after:CUTOFF"

Collect up to each team's max_articles. Fewer is fine. Each bullet is 1–2 sentences, about 35
words max, ending with (Source Name, Month YYYY).

## 4 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Sports News Digest &mdash; The Daily Brief</title>
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
  .group-label { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; padding:2px 8px; border-radius:4px; margin-bottom:12px; }
  .g-primary   { background:#dbeafe; color:#1e40af; }
  .g-secondary { background:#dcfce7; color:#166534; }
  .g-tertiary  { background:#fef9c3; color:#854d0e; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; font-weight:600; margin:16px 0 4px; }
  h3:first-of-type { margin-top:0; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .muted { color:var(--muted); font-size:13px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Sports News Digest</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; injuries &middot; trades &middot; strategies &middot; profiles</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Sports News Digest</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 5 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Sports Digest &mdash; [Month D, YYYY]</div>
<section>
<span class="group-label g-primary">Primary</span>
[each PRIMARY team WITH news: <h3>[Team]</h3><ul><li>Summary. (Source, Month YYYY)</li></ul>]
</section>
<section>
<span class="group-label g-secondary">Secondary</span>
[each SECONDARY team WITH news, same shape]
</section>
<section>
<span class="group-label g-tertiary">Tertiary</span>
[each TERTIARY team WITH news, same shape]
</section>
<section>
<h2>No news this period</h2>
<p class="muted">[comma-separated list of teams SEARCHED today that returned nothing]</p>
</section>
</article>

Omit a group's section entirely when no team in it qualified and ran today.

## 6 — Merge
Keep prior editions dated 1–7 days before today. Because this page publishes twice a week,
the window normally holds one or two prior editions.
MARK_jobs_sports_md

cat > jobs/book.md <<'MARK_jobs_book_md'
# book.html — Book of the Week

Cadence: Thursdays. History: NONE — single book, page replaced wholesale each run, no
<article class="edition"> blocks and no merge step.
Roster: jobs/rosters/books.csv (title,author,year,country,read)

## Gate
None. Runs every Thursday.

## 1 — Pick this week's book
Read jobs/rosters/books.csv from the clone. The CSV row ORDER is the rotation order — never
re-sort it. Pick deterministically:

python3 -c "
import csv, datetime
books=list(csv.DictReader(open('jobs/rosters/books.csv')))
epoch=datetime.date(2026,5,22)
week=(datetime.date.today().toordinal()-epoch.toordinal())//7
b=books[week % len(books)]
print(b['title'],'|',b['author'],'|',b['year'],'|',b['country'])
"

Do NOT pick The Great Gatsby — it was used for the initial deploy. If the rotation lands on it,
take the next row instead.

The CSV has columns, so there is no entry string to parse. An earlier version of this job
parsed a single text column on the " – " separator, which silently skipped every book written
as "Title by Author (Year)" — roughly fifty of them, including Dune, Neuromancer, The Martian
and Fahrenheit 451. They are all in the rotation now. Do not reintroduce string parsing.

The `read` column records whether Jim has already read the book. It is NOT used for selection
today — a book he has read can still come up. Ignore it unless this spec says otherwise.

Three rows have no year (1916, Shantaram, Victory City). Look the year up during research
rather than leaving it blank.

## 2 — Research
Search the web for each of the following. Be accurate — do not invent details.

1. **Cover image URL** — a clean, high-quality cover. Good sources: Open Library
   (https://covers.openlibrary.org/b/isbn/{ISBN}-L.jpg), Wikimedia Commons, publisher sites.
   Must be a direct URL ending in .jpg, .png or .webp that loads publicly.
2. **Genre / literary style** — specific, not generic: "Southern Gothic", "Magical Realism",
   "Postmodern Novel", "Stream of Consciousness".
3. **Page count** — standard edition, approximate is fine.
4. **Plot synopsis** — 3–4 sentences. Vivid and engaging, not Wikipedia-flat. The world of the
   book, the central tension, the emotional core.
5. **Why Jim should read it** — 3–4 sentences written directly to him. Specific about what
   makes it worth his time: style, themes, what kind of reader it is for. A personal
   recommendation, not a blurb.

## 3 — Page shell
Build stamp first line, above the doctype. Long date via `date +"%A, %B %-d, %Y"`.
Substitute every {PLACEHOLDER}. No edition history — write the page complete each run.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="noindex, nofollow">
  <title>Book of the Week — The Daily Brief</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: #0f0f0f; color: #f0ede8; font-family: 'Georgia', 'Times New Roman', serif; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
    header { width: 100%; padding: 28px 32px 20px; text-align: center; border-bottom: 1px solid #222; }
    .header-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #777; margin-bottom: 6px; }
    header h1 { font-size: clamp(22px, 4vw, 34px); font-weight: normal; letter-spacing: 0.02em; }
    .header-date { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 12px; color: #555; margin-top: 8px; letter-spacing: 1px; }
    .back { display: inline-block; font-size: 13px; color: #555; text-decoration: none; margin-top: 10px; }
    .back:hover { color: #999; }
    main { max-width: 760px; width: 100%; padding: 52px 24px 64px; }
    .cover-frame { text-align: center; margin-bottom: 44px; }
    .cover-frame img { max-width: 340px; width: 100%; max-height: 520px; object-fit: contain; border: 1px solid #2a2a2a; box-shadow: 0 0 0 8px #141414, 0 0 0 9px #272727, 0 32px 90px rgba(0,0,0,0.8); display: block; margin: 0 auto; }
    .meta h2 { font-size: clamp(22px, 3.5vw, 30px); font-weight: normal; line-height: 1.25; margin-bottom: 16px; }
    .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 18px 28px; border-top: 1px solid #1e1e1e; padding-top: 20px; margin-bottom: 32px; }
    .meta-item { display: flex; flex-direction: column; gap: 5px; }
    .meta-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #5a5a5a; }
    .meta-value { font-size: 15px; color: #ccc9c2; line-height: 1.4; }
    .section-block { background: #141414; border-left: 2px solid #3a3a3a; border-radius: 2px; padding: 20px 24px; margin-bottom: 18px; }
    .section-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 10px; }
    .section-block p { font-size: 16px; line-height: 1.78; color: #b0aca6; }
    footer { margin-top: auto; padding: 28px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; color: #333; letter-spacing: 1px; text-align: center; }
  </style>
</head>
<body>
<header>
  <div class="header-label">Tarpey Daily Brief</div>
  <h1>Book of the Week</h1>
  <div class="header-date">{THURSDAY_DATE_LONG}</div>
  <a class='back' href='/'>&larr; Back to dashboard</a>
</header>
<main>
  <div class="cover-frame">
    <img src="{COVER_IMAGE_URL}" alt="{TITLE}" onerror="this.style.opacity=0.3">
  </div>
  <div class="meta">
    <h2>{TITLE}</h2>
    <div class="meta-grid">
      <div class="meta-item"><span class="meta-label">Author</span><span class="meta-value">{AUTHOR}</span></div>
      <div class="meta-item"><span class="meta-label">Style</span><span class="meta-value">{LITERARY_STYLE}</span></div>
      <div class="meta-item"><span class="meta-label">Year</span><span class="meta-value">{YEAR}</span></div>
      <div class="meta-item"><span class="meta-label">Pages</span><span class="meta-value">{PAGE_COUNT}</span></div>
    </div>
    <div class="section-block">
      <div class="section-label">Plot Synopsis</div>
      <p>{PLOT_SYNOPSIS}</p>
    </div>
    <div class="section-block">
      <div class="section-label">Why You Should Read It</div>
      <p>{WHY_READ_IT}</p>
    </div>
  </div>
</main>
<footer>Updated Thursdays &middot; Tarpey Daily Brief</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

{THURSDAY_DATE_LONG} format: "Thursday, June 5, 2026"
MARK_jobs_book_md

cat > jobs/rosters/sports-teams.csv <<'MARK_jobs_rosters_sports_teams_csv'
team,max_articles,group,season
Philadelphia Phillies,5,Primary,Feb-Nov
Philadelphia Eagles,5,Primary,Aug-Feb
Villanova Wildcats Basketball,5,Primary,Oct-Mar
Philadelphia Flyers,3,Primary,Sep-Jun
Philadelphia 76ers,3,Primary,Sep-Jun
Carolina Hurricanes,3,Primary,Sep-Jun
Carolina Blaze,3,Secondary,Jun-Oct
Texas A&M Baseball,3,Secondary,Feb-Jun
Texas A&M Softball,3,Secondary,Feb-Jun
Texas A&M Football,3,Secondary,Sep-Jan
College of Wooster Baseball,3,Secondary,Feb-Jun
Penn State Football,3,Secondary,Sep-Jan
Villanova Football,3,Secondary,Sep-Jan
Virginia Cavaliers Baseball,3,Secondary,Feb-Jun
Villanova Wildcats Baseball,3,Secondary,Feb-Jun
Carolina Panthers,3,Secondary,Aug-Feb
New York Giants,2,Tertiary,Aug-Feb
Washington Commanders,2,Tertiary,Aug-Feb
Dallas Cowboys,2,Tertiary,Aug-Feb
Atlanta Braves,2,Tertiary,Feb-Nov
New York Mets,2,Tertiary,Feb-Nov
Los Angeles Dodgers,2,Tertiary,Feb-Nov
St Louis Cardinals,2,Tertiary,Feb-Nov
Charlotte Hornets,2,Tertiary,Sep-Jun
New York Knicks,2,Tertiary,Sep-Jun
Boston Celtics,2,Tertiary,Sep-Jun
MARK_jobs_rosters_sports_teams_csv

cat > jobs/rosters/books.csv <<'MARK_jobs_rosters_books_csv'
title,author,year,country,read
1984,George Orwell,1949,,Yes
Brave New World,Aldous Huxley,1932,,Yes
Childhood's End,Arthur C. Clarke,1953,,
Dune,Frank Herbert,1965,,
Flanagan's Run,Tom McNab,1982,,
Foundation,Isaac Asimov,1951,,
Once a Runner,John L. Parker Jr.,1978,,Yes
Racing the Rain,John L. Parker Jr.,2015,,Yes
The Bolt Velocity,Victor Price,1972,,
The Fast Men,Tom McNab,1986,,
The Front Runner,Patricia Nell Warren,1974,,
The Left Hand of Darkness,Ursula K. Le Guin,1969,,
The Loneliness of the Long-Distance Runner,Alan Sillitoe,1959,,
The Moon Is a Harsh Mistress,Robert A. Heinlein,1966,,
The Rider,Tim Krabbé,1978,,
Twenty Thousand Leagues Under the Sea,Jules Verne,1870,,
1916,Morgan Llywelyn,,,Yes
2666,Roberto Bolaño,2004,Chile/Mexico,
A Farewell to Arms,Ernest Hemingway,1929,,Yes
A Grain of Wheat,Ngũgĩ wa Thiong'o,1967,Kenya,
A Sister to Scheherazade,Assia Djebar,1987,Algeria,
"Absalom, Absalom!",William Faulkner,1936,,
Adventures of Huckleberry Finn,Mark Twain,1884,,Yes
Again to Carthage,John L. Parker Jr.,2007,,Yes
All the King's Men,Robert Penn Warren,1946,,
An American Tragedy,Theodore Dreiser,1925,,
Ancillary Justice,Ann Leckie,2013,,
Anna Karenina,Leo Tolstoy,1877,Russia,
Annihilation,Jeff VanderMeer,2014,,
Arrow of God,Chinua Achebe,1964,Nigeria,
As I Lay Dying,William Faulkner,1930,,
Beloved,Toni Morrison,1987,,
Berlin Alexanderplatz,Alfred Döblin,1929,Germany,
Blindness,José Saramago,1995,Portugal,
Blood Meridian,Cormac McCarthy,1985,,
Buddenbrooks,Thomas Mann,1901,Germany,
By Night in Chile,Roberto Bolaño,2000,Chile,
Candide,Voltaire,1759,France,
Catch-22,Joseph Heller,1961,,partial
Children of Time,Adrian Tchaikovsky,2015,,
Convenience Store Woman,Sayaka Murata,2016,Japan,
Conversation in the Cathedral,Mario Vargas Llosa,1969,Peru,
Crime and Punishment,Fyodor Dostoevsky,1866,Russia,Yes
David Copperfield,Charles Dickens,1850,England,
Dead Souls,Nikolai Gogol,1842,Russia,
Disgrace,J.M. Coetzee,1999,South Africa,
Do Androids Dream of Electric Sheep?,Philip K. Dick,1968,,
Dom Casmurro,Machado de Assis,1899,Brazil,
Don Quixote,Miguel de Cervantes,1605,Spain,Partial
Doña Bárbara,Rómulo Gallegos,1929,Venezuela,
Dracula,Bram Stoker,1897,Ireland/England,
Dream of the Red Chamber,Cao Xueqin,1791,China,
East of Eden,John Steinbeck,1952,,Yes
El Señor Presidente,Miguel Ángel Asturias,1946,Guatemala,
Everything is Beautiful and Everything Hurts,Josie Shapiro,2023,,
Fahrenheit 451,Ray Bradbury,1953,,Yes
Fathers and Sons,Ivan Turgenev,1862,Russia,
Fever Dream,Samanta Schweblin,2014,Argentina,
Ficciones,Jorge Luis Borges,1944,Argentina,
Flowers for Algernon,Daniel Keyes,1966,,Yes
Frankenstein,Mary Shelley,1818,England,
Go Tell It on the Mountain,James Baldwin,1953,,
God's Bits of Wood,Ousmane Sembène,1960,Senegal,
Gone with the Wind,Margaret Mitchell,1936,,
Gravity's Rainbow,Thomas Pynchon,1973,,
Gulliver's Travels,Jonathan Swift,1726,Ireland,
Half of a Yellow Sun,Chimamanda Ngozi Adichie,2006,Nigeria,
Homegoing,Yaa Gyasi,2016,Ghana/USA,
Hopscotch,Julio Cortázar,1963,Argentina,
Houseboy,Ferdinand Oyono,1962,Cameroon,
Housekeeping,Marilynne Robinson,1980,,
Hyperion,Dan Simmons,1989,,
"I, the Supreme",Augusto Roa Bastos,1974,Paraguay,
In Search of Lost Time,Marcel Proust,1913,France,
In the Time of the Butterflies,Julia Alvarez,1994,Dominican Republic,
Invisible Man,Ralph Ellison,1952,,
Jane Eyre,Charlotte Brontë,1847,England,
Journey to the West,Wu Cheng'en,1592,China,
Kafka on the Shore,Haruki Murakami,2002,Japan,
Kindred,Octavia Butler,1979,,
Kiss of the Spider Woman,Manuel Puig,1976,Argentina,
Le Père Goriot,Honoré de Balzac,1835,France,
Les Misérables,Victor Hugo,1862,France,
Like Water for Chocolate,Laura Esquivel,1989,Mexico,
Little Women,Louisa May Alcott,1868,,
Lolita,Vladimir Nabokov,1955,,Yes
Lonesome Dove,Larry McMurtry,1985,,
Love in the Time of Cholera,Gabriel García Márquez,1985,Colombia,
Madame Bovary,Gustave Flaubert,1856,France,
Middlemarch,George Eliot,1871,England,
Midnight's Children,Salman Rushdie,1981,India,
Moby-Dick,Herman Melville,1851,,Tried
Molloy,Samuel Beckett,1951,Ireland,
My Ántonia,Willa Cather,1918,,
My Brilliant Friend,Elena Ferrante,2011,Italy,
My Name Is Red,Orhan Pamuk,1998,Turkey,
Native Son,Richard Wright,1940,,Yes
Nervous Conditions,Tsitsi Dangarembga,1988,Zimbabwe,
Neuromancer,William Gibson,1984,,
Nineteen Eighty-Four,George Orwell,1949,England,Yes
No Longer Human,Osamu Dazai,1948,Japan,
On the Road,Jack Kerouac,1957,,Yes
One Hundred Years of Solitude,Gabriel García Márquez,1967,Colombia,
Pachinko,Min Jin Lee,2017,South Korea/USA,
Pedro Páramo,Juan Rulfo,1955,Mexico,
Please Look After Mom,Shin Kyung-sook,2008,South Korea,
Pride and Prejudice,Jane Austen,1813,England,
Purple Hibiscus,Chimamanda Ngozi Adichie,2003,Nigeria,
"Rabbit, Run",John Updike,1960,,
Robinson Crusoe,Daniel Defoe,1719,England,
Romance of the Three Kingdoms,Luo Guanzhong,1522,China,
Runner 13,Amy McCulloch,2025,,
Running the Rift,Naomi Benaron,2012,,
Season of Migration to the North,Tayeb Salih,1969,Sudan,
Shantaram,Gregory David Roberts,,,
Signs Preceding the End of the World,Yuri Herrera,2009,Mexico,
Sister Carrie,Theodore Dreiser,1900,,
Slaughterhouse-Five,Kurt Vonnegut,1969,,
Sleepwalking Land,Mia Couto,1992,Mozambique,
Snow Country,Yasunari Kawabata,1937,Japan,
Snow Crash,Neal Stephenson,1992,,
So Long a Letter,Mariama Bâ,1979,Senegal,
Song of Solomon,Toni Morrison,1977,,
Station Eleven,Emily St. John Mandel,2014,,
Tender Is the Flesh,Agustina Bazterrica,2017,Argentina,
Tess of the d'Urbervilles,Thomas Hardy,1891,England,
The Adventures of Augie March,Saul Bellow,1953,,
The Age of Innocence,Edith Wharton,1920,,
The Awakening,Kate Chopin,1899,,
The Beautyful Ones Are Not Yet Born,Ayi Kwei Armah,1968,Ghana,
The Betrothed,Alessandro Manzoni,1827,Italy,
The Bluest Eye,Toni Morrison,1970,,
The Book of Choke,Kgebetli Moele,2006,South Africa,
The Book of the New Sun,Gene Wolfe,1980,,
The Brief Wondrous Life of Oscar Wao,Junot Díaz,2007,Dominican Republic/USA,
The Brothers Karamazov,Fyodor Dostoevsky,1880,Russia,
The Cairo Trilogy,Naguib Mahfouz,1956,Egypt,
The Catcher in the Rye,J.D. Salinger,1951,,Yes
The Color Purple,Alice Walker,1982,,
The Count of Monte Cristo,Alexandre Dumas,1844,France,Yes
The Death of Artemio Cruz,Carlos Fuentes,1962,Mexico,
The Devil to Pay in the Backlands,João Guimarães Rosa,1956,Brazil,
The Famished Road,Ben Okri,1991,Nigeria,
The Feast of the Goat,Mario Vargas Llosa,2000,Peru/Dominican Republic,
The Forever War,Joe Haldeman,1974,,
The God of Small Things,Arundhati Roy,1997,India,
The Grapes of Wrath,John Steinbeck,1939,,Yes
The Great Gatsby,F. Scott Fitzgerald,1925,,Yes
The Guide,R.K. Narayan,1958,India,
The Handmaid's Tale,Margaret Atwood,1985,,
The Heart Is a Lonely Hunter,Carson McCullers,1940,,
The Home and the World,Rabindranath Tagore,1916,India,
The Hour of the Star,Clarice Lispector,1977,Brazil,
The House of Mirth,Edith Wharton,1905,,
The House of the Spirits,Isabel Allende,1982,Chile,
The Illegal,Lawrence Hill,2015,,
The Informers,Juan Gabriel Vásquez,2004,Colombia,
The Invention of Morel,Adolfo Bioy Casares,1940,Argentina,
The Joy Luck Club,Amy Tan,1989,,
The Joys of Motherhood,Buchi Emecheta,1979,Nigeria,
The Kingdom of This World,Alejo Carpentier,1949,Cuba,
The Known World,Edward P. Jones,2003,USA,
The Last of the Mohicans,James Fenimore Cooper,1826,,
The Leopard,Giuseppe Tomasi di Lampedusa,1958,Italy,
The Lost Steps,Alejo Carpentier,1953,Venezuela,
The Magic Mountain,Thomas Mann,1924,Germany,
The Makioka Sisters,Jun'ichirō Tanizaki,1943,Japan,
The Man Who Could Move Clouds,Ingrid Rojas Contreras,2022,Colombia,
The Martian,Andy Weir,2011,,Yes
The Master and Margarita,Mikhail Bulgakov,1966,Russia,
The Name of the Rose,Umberto Eco,1980,Italy,
The Obscene Bird of Night,José Donoso,1970,Chile,
The Palm-Wine Drinkard,Amos Tutuola,1952,Nigeria,
The Picture of Dorian Gray,Oscar Wilde,1890,Ireland,
The Pilgrim's Progress,John Bunyan,1678,England,
The Plum in the Golden Vase,Anonymous,1610,China,
The Portrait of a Lady,Henry James,1881,,
The Posthumous Memoirs of Brás Cubas,Machado de Assis,1881,Brazil,
The Radetzky March,Joseph Roth,1932,Austria,
The Red and the Black,Stendhal,1830,France,
The Red Badge of Courage,Stephen Crane,1895,,
The Rings of Saturn,W.G. Sebald,1995,Germany,
The River Between,Ngũgĩ wa Thiong'o,1965,Kenya,
The Road,Cormac McCarthy,2006,,Yes
The Running Dream,Wendelin Van Draanen,2011,,
The Savage Detectives,Roberto Bolaño,1998,Mexico/Chile,
The Scarlet Letter,Nathaniel Hawthorne,1850,,
The Secret in Their Eyes,Eduardo Sacheri,2005,Argentina,
The Seven Madmen,Roberto Arlt,1929,Argentina,
The Shadow King,Maaza Mengiste,2019,Ethiopia,
The Slummer,Geoffrey Simpson,2021,,
The Sorrows of Young Werther,Johann Wolfgang von Goethe,1774,Germany,
The Sound and the Fury,William Faulkner,1929,,
The Stranger,Albert Camus,1942,France,
The Sun Also Rises,Ernest Hemingway,1926,,Yes
The Sympathizer,Viet Thanh Nguyen,2015,Vietnam/USA,
The Tale of Genji,Murasaki Shikibu,1010,Japan,
The Tartar Steppe,Dino Buzzati,1940,Italy,
The Temple of the Golden Pavilion,Yukio Mishima,1956,Japan,
The Three Musketeers,Alexandre Dumas,1844,France,
The Three-Body Problem,Cixin Liu,2008,,Tried
The Time Machine,H.G. Wells,1895,,
The Time of the Hero,Mario Vargas Llosa,1963,Peru,
The Tin Drum,Günter Grass,1959,Germany,
The Trial,Franz Kafka,1925,Austria,
The True Story of Ah Q,Lu Xun,1921,China,
The Tunnel,Ernesto Sabato,1948,Argentina,
The Unbearable Lightness of Being,Milan Kundera,1984,Czechia,
The Underdogs,Mariano Azuela,1915,Mexico,
The Vegetarian,Han Kang,2007,South Korea,
The White Tiger,Aravind Adiga,2008,India,
The Wind-Up Bird Chronicle,Haruki Murakami,1994,Japan,
The Witness,Juan José Saer,1984,Argentina,
The Woman in the Dunes,Kōbō Abe,1962,Japan,
Their Eyes Were Watching God,Zora Neale Hurston,1937,,
Things Fall Apart,Chinua Achebe,1958,Nigeria,
Three Trapped Tigers,Guillermo Cabrera Infante,1967,Cuba,
To Kill a Mockingbird,Harper Lee,1960,,Yes
To the Lighthouse,Virginia Woolf,1927,England,
Tom Jones,Henry Fielding,1749,England,
U.S.A. Trilogy,John Dos Passos,1930,,
Ulysses,James Joyce,1922,Ireland,
Uncle Tom's Cabin,Harriet Beecher Stowe,1852,,
Underworld,Don DeLillo,1997,,
Victory City,Salman Rushdie,,,
War and Peace,Leo Tolstoy,1869,Russia,
Water Margin,Shi Nai'an,1400,China,
Wizard of the Crow,Ngũgĩ wa Thiong'o,2006,Kenya,
Woman at Point Zero,Nawal El Saadawi,1975,Egypt,
Wuthering Heights,Emily Brontë,1847,England,
MARK_jobs_rosters_books_csv

echo "Created:"
ls -1 jobs/enterprise.md jobs/sports.md jobs/book.md jobs/rosters/sports-teams.csv jobs/rosters/books.csv
