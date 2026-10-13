# curio.html — On This Date (Morning Curio)

Cadence: every day (Daily routine). History: rolling 8-day window (today + prior editions 1–7 days old).
Rosters (read from the clone, never edited by this page):
  jobs/rosters/curio-team-questions.csv   bucket,question   — 150 team-building questions
  jobs/rosters/curio-writing-prompts.csv  prompt            — backup writing prompts

Replaced the original Morning Curio format on 2026-10-13 with the "On This Date" format.
jobs/rosters/curio-topics.csv belongs to the old format; this spec does not read or write it.

## Gate
None. Runs every day.

## 0 — Dates and fetch rule
All dates are America/New_York:

    TODAY=$(TZ=America/New_York date +%F)                  # 2026-10-13
    LONG=$(TZ=America/New_York date +"%A, %B %-d, %Y")     # Tuesday, October 13, 2026
    MD=$(TZ=America/New_York date +"%B %-d")               # October 13
    YMD=$(TZ=America/New_York date +%Y/%m/%d)              # 2026/10/13
    ORD=$(python3 -c "import datetime;print(datetime.date.fromisoformat('$TODAY').toordinal())")

FETCH RULE for every API below: try it from the shell first (curl, `--max-time 15`). If the
shell call fails for any reason — HTTP 403, `host_not_allowed`, timeout, non-JSON — fetch the
SAME URL with the WebFetch tool and ask it to return the named fields verbatim. Only when both
fail does a section use its stated fallback. Never invent content to fill a section.

## 1 — On This Date (WebSearch)
Run 2–3 WebSearches: "$MD this day in history", "$MD notable births", "$MD notable deaths".
- Notable Events: 6–10 items, varied eras and categories, no duplicate years, no near-duplicates.
- Notable Births: 3–5 items.
- Notable Deaths: 3–5 items.
Every year and name must match a source. If a claim can't be confirmed, drop it.
Item format, one line each (omit the link if there is no clear source URL):

    <li><strong>{year}</strong> &mdash; {fact} <a href="{source url}">source</a></li>

## 2 — Wikipedia Article of the Day
URL: https://en.wikipedia.org/api/rest_v1/feed/featured/$YMD
Fields: tfa.titles.normalized (TITLE), tfa.content_urls.desktop.page (URL), tfa.extract.
FACT = the first sentence of the extract containing a digit or two consecutive capitalised
words; else the extract's first sentence. If TITLE, URL or FACT is empty, omit the section.

## 3 — Quote of the Day
URL: https://zenquotes.io/api/today → [0].q (QUOTE), [0].a (AUTHOR). ZenQuotes serves one
quote per calendar day, so a same-day re-run gets the same quote.
Never write a quote yourself. If both shell and WebFetch fail, or QUOTE is empty, omit the
section. If the same quote text already appears in a prior edition on the page, keep it anyway
— the source picked it, and a substitute would be invented.

## 4 — Writing Prompt of the Day
Primary: https://www.reddit.com/r/WritingPrompts/top.json?t=day&limit=25 (send
`User-Agent: tarpey-daily-brief/1.0`). Take the first post whose link_flair_text is exactly
"Writing Prompt"; if none, retry with t=week. Strip a leading "[WP]" from the title.
Reddit often refuses automated requests; that is normal, not a failure.
Fallback: jobs/rosters/curio-writing-prompts.csv — row index = ORD mod (row count), counting
data rows from 0. Never write a prompt yourself.
Caption:
- Reddit: From r/WritingPrompts &middot; {score} upvotes &middot; <a href="https://www.reddit.com{permalink}">see thread</a>
- Fallback: From the backup prompt pool
This section is never skipped.

## 5 — Team Building Question of the Day
No network. jobs/rosters/curio-team-questions.csv — row index = ORD mod (row count), counting
data rows from 0. Use the question text verbatim. Never write one yourself. Never skipped.
A missing or unreadable CSV for section 4's fallback or section 5 is a FAILED page.

## 6 — Launch Calendar
Window: TODAY−3 through TODAY+10 inclusive. Launch Library 2 is rate-limited (~15 req/hour):
make exactly these two calls, no retries beyond the WebFetch fallback.

    START = TODAY−3, END = TODAY+10
    https://ll.thespacedevs.com/2.2.0/launch/previous/?window_end__gte=${START}T00:00:00Z&limit=50&mode=list
    https://ll.thespacedevs.com/2.2.0/launch/upcoming/?window_start__lte=${END}T23:59:59Z&limit=50&mode=list

Keep a launch only if launch_service_provider.name matches one of (case-insensitive):
NASA · SpaceX · United Launch Alliance / ULA (whole word) · Blue Origin · JAXA ·
China Aerospace Science and Technology Corporation / CASC / CNSA ·
Indian Space Research Organization(-isation) / ISRO · Roscosmos / Russian Federal Space Agency.
Then keep only window_start dates inside the window. Sort by window_start.
Row fields: date (e.g. "Oct 13 · 2:30 PM UTC"), name (mission), provider, rocket.configuration.name,
pad.location.name, status.name. Row class: past / today / upcoming against TODAY (ET).
Do not add a launch that was not in the API response.
Outcomes:
- both calls failed → <p><em>Launch calendar unavailable this run &mdash; Launch Library API not reachable.</em></p>
- zero matching rows → <p><em>No tracked launches in this window.</em></p>
- otherwise → the table in section 8.

## 7 — Page shell
Build stamp is the first line, above the doctype. Write the file exactly as below.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>On This Date &mdash; The Daily Brief</title>
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
  h2 { font-size:17px; color:var(--navy); margin-bottom:8px; }
  h3 { font-size:14px; margin:12px 0 2px; color:var(--ink); }
  p { font-size:14px; line-height:1.6; margin-bottom:6px; }
  ul { padding-left:20px; } li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  blockquote { font-style:italic; color:#333; border-left:3px solid var(--navy); margin:8px 0; padding-left:12px; font-size:14px; }
  .tbq { font-size:15.5px; font-weight:600; color:var(--navy); border-left:3px solid var(--navy); padding-left:12px; margin:4px 0; }
  .tablewrap { overflow-x:auto; }
  table.launches { width:100%; border-collapse:collapse; font-size:13px; }
  table.launches th { text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:.4px; color:var(--muted); border-bottom:1px solid var(--line); padding:6px 8px; }
  table.launches td { padding:6px 8px; border-bottom:1px solid var(--line); vertical-align:top; }
  table.launches tr.past td { color:var(--muted); }
  table.launches tr.today td { background:#eef2f8; font-weight:600; color:var(--ink); }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>On This Date</h1>
<div class="sub">Latest: [LONG] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS]
</main>
<footer>The Daily Brief &middot; Morning Curio</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 8 — Today's edition block
Sections in this order; an omitted section leaves no heading behind.

<article class="edition" data-date="[TODAY]">
<div class="ed-head">[LONG]</div>
<section><h2>On This Date</h2>
  <h3>Notable Events</h3><ul>[items]</ul>
  <h3>Notable Births</h3><ul>[items]</ul>
  <h3>Notable Deaths</h3><ul>[items]</ul>
</section>
<section><h2>Wikipedia Article of the Day</h2>
  <p><a href="[URL]">[TITLE]</a> &mdash; [FACT]</p>
</section>
<section><h2>Quote of the Day</h2>
  <blockquote>[QUOTE]</blockquote><p>&mdash; [AUTHOR] (via ZenQuotes)</p>
</section>
<section><h2>Writing Prompt of the Day</h2>
  <blockquote>[PROMPT]</blockquote><p>[caption]</p>
</section>
<section><h2>Team Building Question of the Day</h2>
  <p class="tbq">[QUESTION]</p>
</section>
<section><h2>Launch Calendar</h2>
  <div class="tablewrap"><table class="launches">
  <tr><th>Date</th><th>Mission</th><th>Provider</th><th>Rocket</th><th>Site</th><th>Status</th></tr>
  <tr class="[past|today|upcoming]"><td>..</td><td>..</td><td>..</td><td>..</td><td>..</td><td>..</td></tr>
  </table></div>
</section>
</article>

HTML-escape every value taken from an API or CSV (&, <, >, ").

## 9 — Merge
Read the current $WORKDIR/curio.html before overwriting it. Keep every
<article class="edition" data-date="YYYY-MM-DD">…</article> dated 1–7 days before TODAY, in
their existing order, after today's edition. Drop older ones. An existing edition dated TODAY
is replaced, never duplicated. Older editions in the previous Morning Curio format are kept
as-is until they age out.
