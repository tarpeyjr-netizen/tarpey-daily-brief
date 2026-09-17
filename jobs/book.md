# book.html — Book of the Week

Cadence: Thursdays. History: NONE — single book, page replaced wholesale each run, no
<article class="edition"> blocks and no merge step.
Roster: jobs/rosters/books.csv (title,author,year,country,read)

## Gate
None. Runs every Thursday.

## 1 — Pick this week's book
Read jobs/rosters/books.csv from the clone. The CSV row ORDER is the rotation order — never
re-sort it. Pick deterministically:

python3 -c "
import csv, datetime
books=list(csv.DictReader(open('jobs/rosters/books.csv')))
epoch=datetime.date(2026,5,22)
week=(datetime.date.today().toordinal()-epoch.toordinal())//7
b=books[week % len(books)]
print(b['title'],'|',b['author'],'|',b['year'],'|',b['country'])
"

Do NOT pick The Great Gatsby — it was used for the initial deploy. If the rotation lands on it,
take the next row instead.

The CSV has columns, so there is no entry string to parse. An earlier version of this job
parsed a single text column on the " – " separator, which silently skipped every book written
as "Title by Author (Year)" — roughly fifty of them, including Dune, Neuromancer, The Martian
and Fahrenheit 451. They are all in the rotation now. Do not reintroduce string parsing.

The `read` column records whether Jim has already read the book. It is NOT used for selection
today — a book he has read can still come up. Ignore it unless this spec says otherwise.

Three rows have no year (1916, Shantaram, Victory City). Look the year up during research
rather than leaving it blank.

## 2 — Research
Search the web for each of the following. Be accurate — do not invent details.

1. **Cover image URL** — a clean, high-quality cover. Good sources: Open Library
   (https://covers.openlibrary.org/b/isbn/{ISBN}-L.jpg), Wikimedia Commons, publisher sites.
   Must be a direct URL ending in .jpg, .png or .webp that loads publicly.
2. **Genre / literary style** — specific, not generic: "Southern Gothic", "Magical Realism",
   "Postmodern Novel", "Stream of Consciousness".
3. **Page count** — standard edition, approximate is fine.
4. **Plot synopsis** — 3–4 sentences. Vivid and engaging, not Wikipedia-flat. The world of the
   book, the central tension, the emotional core.
5. **Why Jim should read it** — 3–4 sentences written directly to him. Specific about what
   makes it worth his time: style, themes, what kind of reader it is for. A personal
   recommendation, not a blurb.

## 3 — Page shell
Build stamp first line, above the doctype. Long date via `date +"%A, %B %-d, %Y"`.
Substitute every {PLACEHOLDER}. No edition history — write the page complete each run.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="noindex, nofollow">
  <title>Book of the Week — The Daily Brief</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: #0f0f0f; color: #f0ede8; font-family: 'Georgia', 'Times New Roman', serif; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
    header { width: 100%; padding: 28px 32px 20px; text-align: center; border-bottom: 1px solid #222; }
    .header-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #777; margin-bottom: 6px; }
    header h1 { font-size: clamp(22px, 4vw, 34px); font-weight: normal; letter-spacing: 0.02em; }
    .header-date { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 12px; color: #555; margin-top: 8px; letter-spacing: 1px; }
    .back { display: inline-block; font-size: 13px; color: #555; text-decoration: none; margin-top: 10px; }
    .back:hover { color: #999; }
    main { max-width: 760px; width: 100%; padding: 52px 24px 64px; }
    .cover-frame { text-align: center; margin-bottom: 44px; }
    .cover-frame img { max-width: 340px; width: 100%; max-height: 520px; object-fit: contain; border: 1px solid #2a2a2a; box-shadow: 0 0 0 8px #141414, 0 0 0 9px #272727, 0 32px 90px rgba(0,0,0,0.8); display: block; margin: 0 auto; }
    .meta h2 { font-size: clamp(22px, 3.5vw, 30px); font-weight: normal; line-height: 1.25; margin-bottom: 16px; }
    .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(140px, 1fr)); gap: 18px 28px; border-top: 1px solid #1e1e1e; padding-top: 20px; margin-bottom: 32px; }
    .meta-item { display: flex; flex-direction: column; gap: 5px; }
    .meta-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #5a5a5a; }
    .meta-value { font-size: 15px; color: #ccc9c2; line-height: 1.4; }
    .section-block { background: #141414; border-left: 2px solid #3a3a3a; border-radius: 2px; padding: 20px 24px; margin-bottom: 18px; }
    .section-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 10px; }
    .section-block p { font-size: 16px; line-height: 1.78; color: #b0aca6; }
    footer { margin-top: auto; padding: 28px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; color: #333; letter-spacing: 1px; text-align: center; }
  </style>
</head>
<body>
<header>
  <div class="header-label">Tarpey Daily Brief</div>
  <h1>Book of the Week</h1>
  <div class="header-date">{THURSDAY_DATE_LONG}</div>
  <a class='back' href='/'>&larr; Back to dashboard</a>
</header>
<main>
  <div class="cover-frame">
    <img src="{COVER_IMAGE_URL}" alt="{TITLE}" onerror="this.style.opacity=0.3">
  </div>
  <div class="meta">
    <h2>{TITLE}</h2>
    <div class="meta-grid">
      <div class="meta-item"><span class="meta-label">Author</span><span class="meta-value">{AUTHOR}</span></div>
      <div class="meta-item"><span class="meta-label">Style</span><span class="meta-value">{LITERARY_STYLE}</span></div>
      <div class="meta-item"><span class="meta-label">Year</span><span class="meta-value">{YEAR}</span></div>
      <div class="meta-item"><span class="meta-label">Pages</span><span class="meta-value">{PAGE_COUNT}</span></div>
    </div>
    <div class="section-block">
      <div class="section-label">Plot Synopsis</div>
      <p>{PLOT_SYNOPSIS}</p>
    </div>
    <div class="section-block">
      <div class="section-label">Why You Should Read It</div>
      <p>{WHY_READ_IT}</p>
    </div>
  </div>
</main>
<footer>Updated Thursdays &middot; Tarpey Daily Brief</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

{THURSDAY_DATE_LONG} format: "Thursday, June 5, 2026"
