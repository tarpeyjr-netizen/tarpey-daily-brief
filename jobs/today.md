# today — Today (daily morning page)

Published to https://tarpey-daily-brief.pages.dev/today.html. Personal morning page: informal,
brief, scannable. One edition only; each run replaces the page (no history).
Roster: jobs/rosters/today-teams.csv (team, espn_path, espn_id, season, fallback_source).
Timezone for every date and time: America/New_York.

## 1 — Gate
None. Build every day.

## 2 — Build the data sections with the tool
The tool fetches weather (Open-Meteo), the three index closes (Yahoo Finance), every
roster team's schedule (ESPN site API), the No. 1 film of the latest US weekend (Box Office
Mojo), and the No. 1 on five Billboard charts (Hot 100, Billboard 200, Americana/Folk Albums,
Bluegrass Albums, Hot Rock Songs), then writes the complete page. It applies the rules
below itself. Do not re-derive or "correct" its figures.

    BUILD_ID="$BUILD_ID" node jobs/tools/today.mjs "$WORKDIR/today.html" > "$WORKDIR/today.json"
    cat "$WORKDIR/today.json"

Rules the tool already applies, for reference:
- Markets use the most recent COMPLETED trading day (Friday on a Monday) and label that date.
  The note line flags correction territory, 3+ session streaks, and 5-session moves of 2% or more.
- All game times are converted from UTC to ET.
- A team outside its roster season window, or with no game within 3 weeks either side of
  today, is listed in the muted "Off-season" footnote and gets no rows.
- An in-season game with no final score in the feed shows "No result found". Never a guessed score.
- Entertainment: a box-office figure still marked estimated by Box Office Mojo shows "(est.)".
  A chart or box-office fetch that fails shows "Unavailable" and is listed under Gaps.
- W/L is shown as a letter chip and by colour, gains and losses by sign, arrow, and colour.

If the tool exits non-zero, record the page as FAILED with its stderr. Do not hand-build the
data sections.

## 3 — Headlines
Replace the line `<!-- HEADLINES -->` with three top stories from the Associated Press,
published in the last 24 hours. Pick major national or world stories. Skip sports and celebrity items.

apnews.com and reuters.com both refuse Claude's WebFetch and WebSearch (domain blocked, a
permanent error). Do not retry them and do not try to get around the block. Use AP wire stories
republished by PBS NewsHour instead: WebFetch `https://www.pbs.org/newshour/`, keep items whose
byline includes "Associated Press", and fetch each story page you use. Link the PBS URL and
credit it "AP via PBS NewsHour". If PBS fails, WebSearch for AP-bylined stories on other
outlets that carry the wire (ABC News, US News, Yahoo News).

    <section>
    <h2>Headlines</h2>
    <ul class="heads">
    <li><strong>[One-line headline in your own words]</strong><br>[One sentence of detail.] <span class="muted">(<a href="[story URL]">AP via PBS NewsHour</a>, [Mon D])</span></li>
    </ul>
    </section>

Write headlines in your own words, never copied. Use only facts stated in the story. If
fewer than three can be confirmed, show the ones you have and add the shortfall to the Gaps line.

## 4 — Teams the feed could not cover
For each entry in today.json `manual` (in-season teams with no ESPN feed, or a failed
fetch), check its fallback_source site for a game yesterday or today. Replace
the line `<!-- MANUAL_TEAMS -->` with:

    <p class="muted" style="margin-top:10px"><strong>[Team]:</strong> [Yesterday: W/L score vs./at Opp] &middot; [Today: vs./at Opp, time ET or final]</p>

Leave out any part with no game; if neither day has a game, leave the team out. This page covers yesterday and today only: no next-game lines. If the site shows a game but no final score, write
"No result found". If `manual` is empty, delete the placeholder line.

## 5 — Email (not on this page)
This site is public (noindex only, no login). Do NOT put any email content on today.html.

## 6 — Finish
- Update the Gaps line in the Sources section if steps 3 or 4 added a gap.
- Confirm no `<!-- HEADLINES -->` or `<!-- MANUAL_TEAMS -->` placeholder remains.
- Confirm line 1 is `<!-- build: $BUILD_ID -->` (the tool writes it from the env var).
- No merge: this page keeps no prior editions. Commit per _publish.md B6.
