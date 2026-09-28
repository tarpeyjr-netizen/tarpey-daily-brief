# Roster sync — Google Sheets → jobs/rosters/*.csv

Jim edits rosters in Google Sheets ("Tarpey Roster — …" in Drive). The page specs read CSVs
from the clone. This step copies a Sheet into its CSV only when the Sheet has changed since
the last sync, so an unchanged roster costs one metadata search and nothing else.

Run it after _publish.md STEP A (clone) and before STEP B (build pages). It uses the Google
Drive connector and nothing else. It never fails a page: whatever happens here, the pages build from whatever CSV is in
the clone afterwards.

## 1 — Load sync state
Read jobs/rosters/_sync.csv. Keep only the rows whose `pages` value names a page the routine
prompt lists for today (gated pages count — check the roster even if the page later skips).
If no row matches, stop here: report "roster-sync: none due" and go to STEP B. Columns:

    csv                    the file in jobs/rosters/ this Sheet feeds
    pages                  the page(s) that read this CSV, separated by "; "
    sheet_id               Drive file ID — use it, never search by title to pick a file
    sheet_title            for log lines only
    column_map             Sheet header = CSV header, separated by "; "
    synced_modified_time   Drive modifiedTime of the Sheet at the last successful sync

## 2 — One metadata check (no contents)
Make ONE Drive search_files call, with excludeContentSnippets = true:

    mimeType = 'application/vnd.google-apps.spreadsheet' and title contains 'Tarpey Roster'

Match results to rows by sheet_id. For each kept row:

- Sheet modifiedTime > synced_modified_time → CHANGED, go to step 3.
- Otherwise → UNCHANGED. Do not read the Sheet.
- sheet_id not in the results → SKIPPED ("sheet not found"). Keep the existing CSV.

If the Drive connector is unavailable or the call errors, every row is SKIPPED with the
error text. Keep the existing CSVs and continue to STEP B.

## 3 — Rebuild a changed CSV
For each CHANGED row:

1. read_file_content with the sheet_id. Use the first tab.
2. Map columns by header using column_map. Output columns in column_map order. Ignore Sheet
   columns not in the map.
3. Clean every value:
   - Trim surrounding whitespace.
   - Drop rows where every mapped cell is empty.
   - A person, artist or team name written all in lowercase gets each word capitalized
     ("bruce springsteen" → "Bruce Springsteen"). Leave any other casing alone.
   - sports-teams.csv season: three-letter month names joined by a hyphen, no spaces
     ("Sept - June" → "Sep-Jun", "Oct - March" → "Oct-Mar").
   - Do not fix spelling. The Sheet is the source of truth.
4. Keep the Sheet's row order. Some specs treat file order as meaningful.
5. Safety check. Compare data-row counts with the CSV already in the clone. If the new file
   would have zero rows, or fewer than half the old rows, do NOT write it. Mark the row
   HELD with both counts. This guards against a Sheet that was cleared or read badly.
6. Otherwise write the CSV (standard quoting, "\n" line endings, header row first). Set that
   row's synced_modified_time in _sync.csv to the Sheet's modifiedTime from step 2.

## 4 — Commit
If anything changed, commit the changed CSVs and _sync.csv together, before any page:

    git add -- jobs/rosters/_sync.csv jobs/rosters/<each changed csv>
    git diff --cached --quiet || \
      git -c user.email="jamestarpeyjr@gmail.com" -c user.name="Daily Brief Bot" \
          commit -q -m "roster: sync <csv names> from Sheets $(date +%F)"

Only list CSVs that were actually written; never add a pathspec for a file that may not
exist. The commit goes out with the single push in _publish.md STEP C.

## 5 — Report
Add ONE line to the STEP E final response, before the page lines:

    roster-sync: <csv> updated (+A −R), <csv> unchanged, <csv> held — <reason>, <csv> skipped — <reason>

A HELD or SKIPPED roster is a warning, not a failure. It does not change the page count on
the summary line.
