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
