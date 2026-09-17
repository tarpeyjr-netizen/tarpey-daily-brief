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
