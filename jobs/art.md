# art.html — Daily Art

Cadence: every day. History: NONE — this page is replaced wholesale each run, single artwork,
no <article class="edition"> blocks and no merge step.
Roster: jobs/rosters/art-museums.csv (museum,city,country)

## Gate
None. Runs every day.

## 1 — Pick today's museum
Read jobs/rosters/art-museums.csv from the clone. Pick deterministically for today:

python3 -c "import random,datetime,csv; rows=list(csv.DictReader(open('jobs/rosters/art-museums.csv'))); random.seed(datetime.date.today().toordinal()); m=random.choice(rows); print(m['museum'],'|',m['city'],'|',m['country'])"

No fallback list, no warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Find today's artwork
One painting or photograph with a publicly accessible image.

Metropolitan Museum of Art:
1. GET https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isPublicDomain=true&medium=Paintings&q=painting — take a random objectID from the first 300
2. GET https://collectionapi.metmuseum.org/public/collection/v1/objects/{id} — use primaryImage.
   Collect title, artistDisplayName, classification, objectDate, department, medium, accessionYear, creditLine.

Art Institute of Chicago:
1. GET https://api.artic.edu/api/v1/artworks?page={random 1-60}&limit=20&fields=id,title,artist_display,date_display,image_id,classification_title,style_title,short_description&query[bool][must][0][term][is_public_domain]=true&query[bool][must][1][term][artwork_type_title]=Painting
2. Any result with an image_id. Image URL: https://www.artic.edu/iiif/2/{image_id}/full/843,/0/default.jpg

All other museums:
1. Pick a subject/style for today:
   python3 -c "import random,datetime; s=['portrait','landscape','still life','religious scene','mythological scene','genre scene','allegorical','historical','interior','nude figure','animal','seascape','cityscape','battle scene']; random.seed(datetime.date.today().toordinal()+99); print(random.choice(s))"
2. Check what is already on the page to avoid a repeat — the cloned art.html is right there:
   grep -o '<h2>[^<]*</h2>' art.html
   Do not pick that same work again.
3. Search Wikipedia: "{museum name}" {style} painting. Pick ANY work from the results — do NOT
   default to the single most famous work at that museum (not Mona Lisa for the Louvre, not
   The Founding Ceremony of the Nation for the National Museum of China). Variety is the goal.
4. The work must have a Wikimedia Commons image (https://upload.wikimedia.org/...). Verify the
   URL ends in .jpg or .png. If none, try a different style from the list.

## 3 — Fields to collect
Title (full) · Artist (name and dates if known) · Style (movement or classification) ·
Year (date or range) · Museum (full name with city/country from the CSV) · Image URL ·
Interesting Fact (2–3 engaging sentences: a surprising story, a historical controversy, an
unusual detail — not generic filler).

## 4 — Page shell
Build stamp first line, above the doctype. Long date via `date +"%A, %B %-d, %Y"`.
Substitute every {PLACEHOLDER}. This page has no edition history — write it complete each run.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="robots" content="noindex, nofollow">
  <title>Daily Art — The Daily Brief</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { background: #0f0f0f; color: #f0ede8; font-family: 'Georgia', 'Times New Roman', serif; min-height: 100vh; display: flex; flex-direction: column; align-items: center; }
    header { width: 100%; padding: 28px 32px 20px; text-align: center; border-bottom: 1px solid #222; }
    .header-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; letter-spacing: 3px; text-transform: uppercase; color: #777; margin-bottom: 6px; }
    header h1 { font-size: clamp(22px, 4vw, 34px); font-weight: normal; letter-spacing: 0.02em; }
    .header-date { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 12px; color: #555; margin-top: 8px; letter-spacing: 1px; }
    .back { display: inline-block; font-size: 13px; color: #555; text-decoration: none; margin-top: 10px; }
    .back:hover { color: #999; }
    main { max-width: 880px; width: 100%; padding: 52px 24px 64px; }
    .artwork-frame { text-align: center; margin-bottom: 44px; }
    .artwork-frame img { max-width: 100%; max-height: 74vh; object-fit: contain; border: 1px solid #2a2a2a; box-shadow: 0 0 0 8px #141414, 0 0 0 9px #272727, 0 32px 90px rgba(0,0,0,0.8); display: block; margin: 0 auto; }
    .meta h2 { font-size: clamp(22px, 3.5vw, 30px); font-weight: normal; line-height: 1.25; margin-bottom: 16px; }
    .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 18px 28px; border-top: 1px solid #1e1e1e; padding-top: 20px; margin-bottom: 32px; }
    .meta-item { display: flex; flex-direction: column; gap: 5px; }
    .meta-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #5a5a5a; }
    .meta-value { font-size: 15px; color: #ccc9c2; line-height: 1.4; }
    .fact-block { background: #141414; border-left: 2px solid #3a3a3a; border-radius: 2px; padding: 20px 24px; }
    .fact-label { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 10px; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 10px; }
    .fact-block p { font-size: 16px; line-height: 1.78; color: #b0aca6; }
    footer { margin-top: auto; padding: 28px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 11px; color: #333; letter-spacing: 1px; text-align: center; }
  </style>
</head>
<body>
<header>
  <div class="header-label">Tarpey Daily Brief</div>
  <h1>Daily Art</h1>
  <div class="header-date">{TODAY_LONG_DATE}</div>
  <a class="back" href="index.html">&larr; Back to dashboard</a>
</header>
<main>
  <div class="artwork-frame">
    <img src="{IMAGE_URL}" alt="{TITLE}" onerror="this.style.opacity=0.3">
  </div>
  <div class="meta">
    <h2>{TITLE}</h2>
    <div class="meta-grid">
      <div class="meta-item"><span class="meta-label">Artist</span><span class="meta-value">{ARTIST}</span></div>
      <div class="meta-item"><span class="meta-label">Style</span><span class="meta-value">{STYLE}</span></div>
      <div class="meta-item"><span class="meta-label">Year</span><span class="meta-value">{YEAR}</span></div>
      <div class="meta-item"><span class="meta-label">Museum</span><span class="meta-value">{MUSEUM}</span></div>
    </div>
    <div class="fact-block">
      <div class="fact-label">Interesting Fact</div>
      <p>{FACT}</p>
    </div>
  </div>
</main>
<footer>Updated daily &middot; Tarpey Daily Brief</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>
