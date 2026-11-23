# weekly-training.html — Weekly Training

Cadence: every day (part of the Daily routine). History: NONE — the page is regenerated whole each
run by a script, no editions and no merge step. It sits beside training.html (the per-exercise
tracker, Mondays and Fridays); the two pages do not share code or data.

Shows, per Monday-start week: running miles and minutes, rowing miles and minutes, and the weekly
max for bench, squat, deadlift and overhead press (barbell, Swiss bar and dumbbell combined,
dumbbells counted as the pair). Tiles, charts, one-row-per-week table with an Average row, and a
new-high ring on the lift charts.

Everything is computed by `tools/weekly_training.py` from three inputs. Do not hand-write the page,
do not research anything on the web, and do not estimate a missing number.

## Gate
None. Runs every day.

## 1 — Inputs (THIS PAGE NEEDS THE GOOGLE DRIVE CONNECTOR)

a. Running log — Google Sheet "2026 Tracker", fileId `1ejIIxiPzVu6hvUDMDyAiGvCVS9Rm8DzpQjeADa7uvm4`.
   Call the Drive connector's download_file_content with
   exportMimeType `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`.
   The tool saves the .xlsx to a path it prints; if it returns base64 inline instead, decode it
   (`base64 -d`) into `$WORKDIR/tracker.xlsx`. Do NOT use read_file_content for this sheet: it only
   returns a sample of rows.

b. Lifting log — Google Doc, fileId `1kOu681X9cQD3vYJNJhWiYSriB22qlzVxGyMYNoW8t54` (the same doc
   training.md reads). Call read_file_content. The result is large and is saved to a file; use that
   file as-is (the script accepts the raw JSON `{"fileContent": ...}` or plain text). If the result
   comes back inline, write it unchanged to `$WORKDIR/lifting-doc.txt`.

c. Rowing — `jobs/data/rowing-weekly.csv` in the clone (weekly meters and minutes from the Concept2
   logbook, with an `# as_of:` date on the third line). No connector reads Concept2. If the file's
   as_of is more than 3 days old the page shows a stale-rowing warning on its own; that is
   expected, not a failure. Never edit this file from a routine unless a human asked.

If a. or b. fails or comes back empty, this is a FAILED page — report the error. Do not publish a
page built from stale or invented data. The page keeps the last good version.

## 2 — Build
python3 -c "import openpyxl" 2>/dev/null || pip install -q --break-system-packages openpyxl

BUILD_ID=$(date -u +%Y-%m-%dT%H%M%SZ)
TODAY=$(TZ=America/New_York date +%F)
python3 tools/weekly_training.py \
  --xlsx "$WORKDIR/tracker.xlsx" --doc "<path to the doc result file>" \
  --rowing jobs/data/rowing-weekly.csv --template tools/weekly_training_template.html \
  --out "$WORKDIR/weekly-training.html" --build-id "$BUILD_ID" --today "$TODAY"

The script prints one line: `weeks=N runs_total=N rowing_as_of=DATE -> <file>`. Sanity checks
before committing — if either fails, record the page FAILED and do not commit:
  - weeks is at least 47 and runs_total is at least 150
  - the output's first line is `<!-- build: <BUILD_ID> -->`

The build stamp is the first line of the file; the shared publish block (STEP B 6 and STEP D) then
commits and verifies it like any other page.

## 3 — Limits to know about
- The running log is the "Workout Log" tab of the 2026 Tracker; the script assumes its rows carry
  their own year and the lifting doc is newest-first with headings like `11/22` or `Sunday 11/22`.
  If a new year's tracker or doc layout appears, the page needs a human to repoint these inputs.
- The Sheet's Workout Log counts a run only when its distance cell is a number greater than zero.
- Lift numbers are parsed from free text. A heading the parser does not recognise is skipped, not
  guessed. `python3 tools/weekly_training.py ... --dump-weekly weekly.csv` writes the computed
  weekly table for checking.
