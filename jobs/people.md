# people.html — People Update

Cadence: Wednesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/people.csv (person,profession) + jobs/rosters/people-sources.csv (their feeds)

## Gate
None. Runs every Wednesday.

## 1 — Week
The 7 days ending yesterday. Compute fresh via bash `date`; ISO via `date +%F`.

## 2 — Roster
Read jobs/rosters/people.csv from the clone. Cover every person, in file order. No fallback
roster and no warning banner. A missing or unreadable CSV is a FAILED page.

jobs/rosters/people-sources.csv (person,kind,source,url,match) lists each person's OWN
channels — newsletter, blog, column, podcast — as RSS/Atom feeds. It is edited in the repo, not
in the Google Sheet, and the roster sync never touches it. A person with no row there is
covered by search only.

## 2a — Feeds first (costs no searches)
Why: on 2026-11-11 this page reported "No major updates" for 48 of 59 people. The page ran
last on its routine and the shared WebSearch budget was gone before most people were searched.
Feeds are fetched from the shell and do not touch that budget.

Run once, before any search:

  python3 jobs/tools/people_feeds.py 8

It prints, per person: FEED_ITEM lines (date | source | title | link | summary) for everything
they published in the window, FEED_QUIET when a feed had nothing new, FEED_FAILED when a feed
could not be read, or NO_FEED.

- FEED_ITEM: these are the person's update. Keep items dated inside the step 1 week. Write the
  update from the titles and summaries; when a summary is too thin to say something specific,
  WebFetch that item's link. Link the items in the Sources line. Do not pad: 2–4 of the most
  interesting items, not the whole list (Tyler Cowen and Simon Willison post many times a day).
- FEED_FAILED: fetch the same url with WebFetch and read the items from it. Do not retry the
  shell another way.
- A podcast feed gives the person's own show. Guest spots on other shows still need step 3.

## 2b — Search plan and budget
WebSearch is capped per run and shared with the other pages on the routine (see _publish.md,
RESEARCH BUDGET). Spend it in this order, in waves of about 8 people per research agent:

  Wave 1 — everyone with NO_FEED, or with feeds but no FEED_ITEM in the week: the three
           searches in step 3, mode "extended".
  Wave 2 — everyone who already has feed items: ONE search,
           "[Name] interview OR podcast guest [Month YYYY]", to catch appearances elsewhere.

Give each agent its quota (people x searches) in its brief. An undated result is not a reason
to drop an item: fetch the page, find its date, include it if it falls in the week.

If WebSearch refuses mid-run, stop searching and build the page from what is in hand. Every
agent reports which people it did not finish.

Three outcomes per person — they are different and must not be merged:
  - has news                      → the update paragraph and a Sources line
  - searched, nothing found       → "No major updates this week."
  - not searched (budget ran out, no feed) → "Not checked this week."
Never write "No major updates this week." for someone who was not actually searched.

## 2c — Keep the sources file growing
When a search this run turns up a channel the person owns (their newsletter, blog or podcast —
not an outlet that merely covered them), find its feed URL, add a row to
jobs/rosters/people-sources.csv, and re-run the tool. Keep the row only if the tool prints
FEED_ITEM or FEED_QUIET for it; delete it on FEED_FAILED. Check the feed is really theirs —
a same-name stranger's newsletter has been cited on this page before. Commit the CSV with
people.html and name the additions in the STEP E line.

## 3 — Research, last 7 days
Per person in Wave 1:
- "[Name] news [Month YYYY]"
- "[Name] interview OR podcast [Month YYYY]"
- "[Name] new book OR article OR column [Month YYYY]"

SOURCE LINKS — every item of news must be traceable. While researching, record the URL of the
page each fact came from (article, podcast episode page, newsletter post, video, official
site) next to the fact. Never guess, rebuild or reuse a URL from memory: only link a URL a
search or fetch actually returned in this run. If you have a fact but no URL for it, say so
in the paragraph ("source link not found") rather than inventing one.

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
  a { color:var(--navy); }
  .src { font-size:13px; color:var(--muted); }
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
<div class="ed-head">Week ending [Wednesday DD, YYYY] &middot; [N] with news &middot; [N] quiet &middot; [N] not checked</div>
<section><h2>This Week</h2><p>[One or two sentences: the most interesting update of the week across everyone]</p></section>
<section><h2>Updates</h2>
[per person: <h3>Name &mdash; Profession</h3><p>Update: [what happened, what was published, what was said — specific and interesting, quote if notable. If searched and nothing found: "No major updates this week." If not searched: "Not checked this week."]</p>
  Under every person who has news, add one line of 1–3 source links:
  <p class="src">Sources: <a href="URL">Outlet or show, Mon D</a> &middot; <a href="URL">...</a></p>
  Link text names the outlet or show and the date, never a bare URL or "click here". Link the
  specific item (the episode, the article), not a site home page. A person with no news gets
  no Sources line.]
</section>
</article>

## 6 — Merge
Keep prior editions dated 1–7 days before today.
