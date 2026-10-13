# podcasts.html — Podcast Tracker

Cadence: daily, built by the Daily routine (4:00 AM ET). History: rolling 7-day window (today + prior editions 1–6 days old).
Roster: jobs/rosters/podcasts.csv (sheet_name,podcast,feed_url)

## Gate
None.

## 1 — Window
The 48 hours ending at run time. Compute with bash `date`; ET for display, UTC for comparison.
The window only limits what is fetched. It overlaps the previous run on purpose, so a missed
day loses nothing. What gets published is decided by step 3b: each episode appears exactly once,
in the first edition that found it.

## 2 — Roster
Read jobs/rosters/podcasts.csv from the clone. Cover every show, in file order.

- `sheet_name` is the name as Jim typed it in his Google Sheet ("Tarpey  Rsoter - Podcasts",
  owned by jimtarpeybot@gmail.com). It may contain typos; it is for reference only.
- `podcast` is the show's real title. `feed_url` is its public RSS feed.
- A row with an empty `feed_url` (a show Jim just added): look the show up with the Apple
  Podcasts search API (`https://itunes.apple.com/search?term=<name>&media=podcast&limit=5`),
  pick the active show whose title matches, write its `feedUrl` and real title into the CSV,
  and commit the CSV with the page. If no confident match, list the show under "Couldn't find"
  rather than guessing. Apple throttles: wait 20 s between lookups, back off 45 s on HTTP 403.

This roster is not in _roster-sync.md: the Sheet lives in a different Drive account, has no
header row, and holds names only. Edit the CSV here.

## 3 — Pull episodes (no web search needed)
Fetch every feed directly from the shell (curl/python, User-Agent set). For each `<item>` with a
`pubDate` inside the window keep: title, pubDate, itunes:duration, link, itunes:summary or
description (HTML stripped). Record each show's newest pubDate even when it is outside the window.

NETWORK — routine environments may restrict outbound hosts. If the shell fetch of a feed is
refused (403, "host_not_allowed", connection blocked), fetch the same feed URL with WebFetch
instead and read the items from its output. Do not retry the shell through another command.
Only after both fail does the show go under "Couldn't check".

A feed that fails to fetch or parse: list the show under "Couldn't check" with the error text.

Also keep each item's `<guid>` (fall back to the enclosure URL if there is no guid).

Collapse duplicate cuts of one episode (e.g. Chuck ToddCast posts "Full Episode", "Chuck's
Commentary" and "Interview Only" versions): show the full episode once and note the other cuts.

## 3b — Drop episodes already published (required)
Before writing anything, read the current podcasts.html from the clone and collect every episode
in the editions you are keeping (step 8 — not the same-date edition being replaced). Remove from
today's list any episode that matches one of those:

1. Same `data-guid` value (every episode section carries one — see step 7). Primary key.
2. For older sections with no `data-guid`: same show name AND the same publish time in the meta
   line ("Mon Oct 12, 5:00 AM ET").

Do NOT match on title. Shows retitle episodes after release (Diary of a CEO renamed its Eric
Weinstein episode overnight), and a title match lets the same episode through twice.

A show whose in-window episodes were all removed counts as quiet for today (step 7).
If nothing new remains for any show, still publish the edition: the header says
"0 new episodes" and the quiet list shows every show. Never repeat old episodes to fill it.

## 4 — Summaries
Write each summary yourself from the show notes: 2–3 sentences, who is on and what they cover.
Neutral voice. Hosts' and guests' claims and opinions are attributed to them ("Todd argues…"),
never stated as fact, and loaded wording from show titles or notes is not repeated as the
page's own voice. Drop sponsor reads, timestamps and social handles.

## 5 — Links
Per episode, in this order:
1. **Listen on Spotify** — `https://open.spotify.com/search/<URL-encoded episode title>`.
   Spotify episode pages are not indexed until days after release and its API is not reachable
   from routines, so the search link is the standard. Use a direct open.spotify.com/episode URL
   only if the feed itself provides one.
2. **Show notes** — the item's `<link>` only if it is episode-specific (not a network home page
   or a generic show page). Otherwise omit.

## 6 — Page shell
Same shell and CSS as people.html (navy header, white section cards, "Back to dashboard"),
title "Podcast Tracker", sub-line "Latest: [Day Mon D, YYYY] · new episodes since the last edition
· showing the last 7 days". Build stamp first line, above the doctype.

## 7 — Edition block
<article class="edition" data-date="[TODAY ISO]">
  ed-head: "[Weekday, Month D, YYYY] — [N] new episodes from [M] of [T] shows"
  One <section class="ep" data-guid="[guid, HTML-escaped]"> per NEW episode, newest first:
    show name (small caps line) · episode title (h3) · "Mon D, h:mm AM ET · 1h 53m" ·
    summary paragraph · Spotify button + Show notes link
  <section> "Nothing new since the last edition": one line per show with no new episode today
    (including shows whose recent episodes already appeared in an earlier edition), newest
    first, with its last release date ("Conversations with Tyler — last episode Sep 30").
  Optional sections "Couldn't check" / "Couldn't find" only when non-empty.
</article>

## 8 — Merge
Keep prior editions dated 1–6 days before today. Same-date re-run replaces.

## 9 — index.html
Card already exists in the "Other" section. Do not edit index.html.
