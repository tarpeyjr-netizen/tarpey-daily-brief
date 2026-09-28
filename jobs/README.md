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

Each spec reads its CSV out of the clone. There are no fallback tables and no "roster
warning" banners — a missing or unreadable CSV is a failed page.

Twelve rosters are edited in Google Sheets ("Tarpey Roster — …" in Drive) and copied into
their CSVs by `_roster-sync.md`. Each routine checks only the Sheets its pages use, right
before building, and reads a Sheet only if it changed since the last sync. The Sheet →
CSV mapping and last-sync times live in `rosters/_sync.csv`.

    Sheet-managed (edit the Sheet, not the CSV — a CSV edit is overwritten on the next
    Sheet change): music, mlb, nfl, track, people, sports-teams, stocks, ai-tools, nba,
    college-baseball, college-football, sap-vendors

The NBA job still corrects a player's team in nba.csv when he moves, and flags it in its
report so the NBA Sheet can be updated to match.

All other rosters are edited here in GitHub (pencil icon, commit) or by asking Claude in a
session with this repo selected. Their old Google Sheets from July are stale and not read.

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
