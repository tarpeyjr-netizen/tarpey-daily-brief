# curio.html — Morning Curio

Cadence: every day (Daily routine). History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/curio-topics.csv (date,category,topic) — the log of every topic already used.

This spec was reconstructed on 2026-10-13 from the page's own editions (Sep 1–8, 2026). The page
had no spec after the move to cloud routines and stopped publishing after Sep 8.

## Gate
None. Runs every day.

## 1 — Date
Today in ET: `TZ=America/New_York date +%F` and `date +"%A, %B %-d, %Y"`.

## 2 — Topic log (no repeats, ever)
Read jobs/rosters/curio-topics.csv. Every History & Geography, Business & Society, Sports and
Religion & Philosophy item today must be a topic NOT already in the log for that category —
compare by subject, not exact wording ("Erie Canal 1825" and "Clinton's Ditch" are the same).
After building, append one row per item (today's date, category, topic as shown in the h3) and
commit the CSV with the page. A missing or unreadable CSV is a FAILED page.

Quotes may repeat an author but never the same quote within the 8 editions on the page.

## 3 — Research and accuracy
These are evergreen facts, but every number, date and name must be right. For each item, use at
least one WebSearch (and WebFetch the best source when a figure matters) before writing it. If a
claim can't be confirmed, drop the claim or pick another topic. No invented statistics.

On This Day: 8–9 events for today's month and day, verified, spanning ancient to modern, mixing
politics, science, culture and disasters. Format: <li><strong>YEAR</strong> &mdash; one sentence.</li>

Quotes for Consideration: four quotes, each with an h3 naming the source (rotate philosophers,
statesmen, writers, business figures; include one Bible verse about every other day, with its
reference). Only genuine, sourced quotes — avoid well-known misattributions.

## 4 — Sections and fixed categories (every edition, this order)
Each item: <h3>Category &middot; Topic</h3> then one <p> of 3–4 sentences. Lead with the
concrete fact, end with the counterintuitive or surprising angle.

- On This Day
- Quotes for Consideration
- History &amp; Geography: American History · World History · Geography · Japan · Ireland ·
  India · South America · Durham NC
- Business &amp; Society: Economics · Finance · Personal Finance · Management · Constitutional Law
- Sports: Track and Field · Softball · Mayo GAA · Athletics (sports psychology / skill
  acquisition — the past editions treat this as the science of performance, not results)
- Religion &amp; Philosophy: Catholicism · World Religion

## 5 — Page shell
Build stamp first line, above the doctype. Keep the existing <head> CSS from curio.html exactly
(navy header, white section cards, blockquote style). Header: "← Back to dashboard",
h1 "Morning Curio", sub "Latest: [Weekday, Month D, YYYY] · showing the last 8 days".
Footer: "The Daily Brief · Morning Curio" plus the script that opens main links in a new tab.

## 6 — Edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">[Weekday, Month D, YYYY]</div>
[the six <section>s above, each with <h2>]
</article>

## 7 — Merge
Keep prior editions dated 1–7 days before today; drop older ones. Same-date re-run replaces.
