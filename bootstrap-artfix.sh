#!/usr/bin/env bash
# Fixes the art job and the same latent bug in retirement.
# Both specs told the model to reach non-allowlisted hosts from the session network.
# Run from the repo root, then commit and push to main.
set -euo pipefail
mkdir -p jobs/rosters

cat > jobs/art.md <<'MARK_jobs_art_md'
# art.html — Daily Art

Cadence: every day. History: NONE — this page is replaced wholesale each run, single artwork,
no <article class="edition"> blocks and no merge step.
Roster: jobs/rosters/art-museums.csv (museum,city,country)

## Gate
None. Runs every day.

## NETWORK — read this before fetching anything
This routine's environment uses a CUSTOM network allowlist containing only
tarpey-daily-brief.pages.dev and the standard package managers.

- WebFetch and WebSearch route through Anthropic's servers, NOT the session network. They
  reach any host and are the ONLY way this page may retrieve remote data.
- Bash curl/wget go through the session network. Any host except tarpey-daily-brief.pages.dev
  returns 403 host_not_allowed.

Therefore: every "GET" below means **WebFetch**. Never curl the Met API, the Art Institute
API, Wikipedia, or upload.wikimedia.org — those calls cannot succeed here. The only permitted
curl in this spec is against tarpey-daily-brief.pages.dev.

Image URLs are validated by INSPECTION, not by fetching: confirm the URL is on
upload.wikimedia.org (or the museum's own CDN) and ends in .jpg, .png or .webp. The page
template already carries an onerror handler for the rare dead link.

## 1 — Pick today's museum
Read jobs/rosters/art-museums.csv from the clone. Pick deterministically for today:

python3 -c "import random,datetime,csv; rows=list(csv.DictReader(open('jobs/rosters/art-museums.csv'))); random.seed(datetime.date.today().toordinal()); m=random.choice(rows); print(m['museum'],'|',m['city'],'|',m['country'])"

No fallback list, no warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Find today's artwork
One painting or photograph with a publicly accessible image.

Metropolitan Museum of Art:
1. WebFetch https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isPublicDomain=true&medium=Paintings&q=painting — take a random objectID from the first 300
2. WebFetch https://collectionapi.metmuseum.org/public/collection/v1/objects/{id} — use primaryImage.
   Collect title, artistDisplayName, classification, objectDate, department, medium, accessionYear, creditLine.

Art Institute of Chicago:
1. WebFetch https://api.artic.edu/api/v1/artworks?page={random 1-60}&limit=20&fields=id,title,artist_display,date_display,image_id,classification_title,style_title,short_description&query[bool][must][0][term][is_public_domain]=true&query[bool][must][1][term][artwork_type_title]=Painting
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

## 2B — Fallback chain, in order
Do not abandon the page on the first failure. Work down this list:

1. The museum-specific path in section 2 (Met API, Art Institute API, or the Wikipedia search
   for every other museum).
2. If a museum's API returns nothing usable after two attempts, switch to the generic
   Wikipedia route for that same museum: WebSearch "{museum name}" {style} painting, then take
   any work with a Commons image.
3. If that museum yields nothing, re-roll the museum with a seed offset (+1, +2, …) and try
   again — up to three museums total.
4. Only if all three produce no usable artwork, FAIL the page with the marker
   FAIL_NO_ARTWORK and the last error seen. Do NOT publish a page with a broken or missing
   image, and do NOT leave the previous day's artwork in place while claiming success.

Echo a one-line progress note at each step (museum picked, route used, image URL chosen) so a
failure names the step it died at.

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
MARK_jobs_art_md

cat > jobs/retirement.md <<'MARK_jobs_retirement_md'
# retirement.html — Retirement Destination Profile

Cadence: Fridays. History: today's edition + up to 5 prior (6 total).
Roster: jobs/rosters/retirement-destinations.csv (type,destination) — US rows first, then INTL.
CSV row ORDER within each type is the rotation order. Never re-sort it.

## Gate
None. Runs every Friday.

## 1 — Pick the destination
IMPORTANT — this job previously ran on SUNDAYS and its rotation was written around Sundays.
It now runs on FRIDAYS. The old algorithm, evaluated on a Friday, returned Asheville every
single US week and never advanced, because its loop walked Sundays and tested `d == today`,
which a Friday never satisfies. The corrected version below keys off the nth occurrence of the
run day in its month, which is weekday-agnostic. Do not reintroduce any Sunday logic.

International week = the SECOND Friday of the month. Every other Friday is a US week.

python3 - <<'PY'
import csv, datetime
rows=list(csv.DictReader(open('jobs/rosters/retirement-destinations.csv')))
US=[r['destination'] for r in rows if r['type']=='US']
INTL=[r['destination'] for r in rows if r['type']=='INTL']
today=datetime.date.today()
SEED=datetime.date(2026,7,21)          # Asheville seed, already published
nth=lambda d:(d.day-1)//7+1            # nth occurrence of this weekday in its month
is_intl = nth(today)==2
if is_intl:
    months=(today.year-2026)*12+(today.month-8)
    dest=INTL[months % len(INTL)]
else:
    f=SEED+datetime.timedelta(days=(4-SEED.weekday())%7)   # first Friday after the seed
    if f<=SEED: f+=datetime.timedelta(days=7)
    count, idx = 1, 0                   # start at 1 — index 0 (Asheville) was the seed
    while f<=today:
        if nth(f)!=2:
            if f==today: idx=count
            count+=1
        f+=datetime.timedelta(days=7)
    dest=US[idx % len(US)]
print(f"IS_INTL={is_intl}")
print(f"DESTINATION={dest}")
PY

Use the printed values for the rest of the run. When IS_INTL is true, note the country name
separately from the city/region.

The original prompt carried a guard for the seed date 2026-07-21. That date is in the past and
fell on a Tuesday, so a Friday routine can never hit it. No guard is needed.

## 2 — Research
WebSearch for accurate, current data. Never guess — if a figure cannot be found, write
"not readily available". 8–14 searches total, batching related topics.

1. Overall population — city and metro (or town and nearest major metro internationally)
2. Retirement-age population — % aged 65+, or the best retiree/expat proxy internationally
3. Climate — brief characterization
4. Distance to mountains — nearest range or hiking area, miles and drive time
5. Distance to beach/coast — nearest ocean or major lake beach, miles and drive time
6. Nearest airport — name/code, distance, roughly how many nonstops or notable direct routes;
   internationally, whether there is a direct or one-stop route back to the US
7. Walkability & transit — Walk Score if one exists (cite walkscore.com), noting any gap
   between citywide and downtown scores, plus a line on transit. Qualitative where no score
   exists.
8. Crime & safety — violent and property crime vs national average (NeighborhoodScout,
   AreaVibes, City-Data), with trend direction; Numbeo Safety Index internationally
9. Cost of living — index vs national average (or vs the home country internationally), a
   monthly figure if available, housing broken out
10. Taxes on retirement income — whether Social Security, pension and 401(k)/IRA withdrawals
    are taxed; state/local income tax rate; local property tax rate and any senior or homestead
    exemption. Internationally: residency and tax-treaty treatment of foreign retirement
    income, plus the local property tax equivalent
11. Housing — median home price / index vs national average, AND the recent price trend
    specifically for 2–3 bedroom homes, with a % if available. Cite Zillow, Redfin or local
    sources
12. Natural disaster risk & insurance — dominant risks, notable recent disaster history, and
    the state of the local home insurance market
13. Sports & leisure proximity — nearest pro franchises (or international equivalents: top-flight
    football, rugby, F1) and notable college athletics. Where pro sports are not a natural fit,
    note the nearest major sports or cultural hub rather than omitting the section
14. Senior services & community — number/range of 55+, independent living and CCRC options, a
    notable example, continuing-education programs, volunteer and civic opportunities.
    Internationally: expat community size, expat services, retiree visa or residency program
15. Healthcare — the leading local or regional hospital or health system and its rating
    (U.S. News, Healthgrades, CMS stars; internationally JCI accreditation, Numbeo Healthcare
    Index, or a recognized international ranking)

Prefer primary sources: Zillow, Redfin, US News, Healthgrades, Numbeo, NeighborhoodScout,
Walk Score, official city/county/state tax sites, World Population Review.

## 3 — Three photos
Wikimedia Commons hotlinks. Web page screenshots and WebFetch do not reliably return raw image
URLs, so use this exact recipe:

1. WebSearch `"File:" [destination] site:commons.wikimedia.org` and the same for a notable
   landmark or natural feature, to collect 3–5 candidate file titles.
2. Compute each direct hotlink — the upload path is the MD5 of the underscored title:

python3 - <<'PY'
import hashlib, urllib.parse
files=["Exact File Title One.jpg","Exact File Title Two.jpg","Exact File Title Three.jpg"]
for f in files:
    t=f.replace(" ","_"); h=hashlib.md5(t.encode()).hexdigest()
    print(f"https://upload.wikimedia.org/wikipedia/commons/{h[0]}/{h[0:2]}/{urllib.parse.quote(t)}")
PY

3. Validate each by INSPECTION, not by fetching. This routine's environment uses a custom
   network allowlist containing only tarpey-daily-brief.pages.dev and the package managers, so
   a curl to upload.wikimedia.org returns 403 host_not_allowed and can never confirm anything.
   Confirm instead that the computed URL is on upload.wikimedia.org and ends in .jpg, .png or
   .webp, and that the file title came from an actual Commons search result rather than being
   invented. The page template already carries an onerror handler for a rare dead link.
   Prefer candidate titles that appeared in more than one search result.
4. Finish with exactly 3 verified URLs, each with a short caption and its
   https://commons.wikimedia.org/wiki/File:... page URL for attribution.
5. If Commons will not yield 3, fall back to direct hotlinkable .jpg/.png URLs from official
   tourism board or city government sites. Never use stock marketplaces (Getty, iStock,
   Shutterstock) — those do not hotlink.

## 4 — Page shell
Build stamp first line, above the doctype. Reuse the existing retirement.html <head> style
block verbatim from the clone — it already defines .photo-grid, .photo-grid img and
.photo-grid figcaption. Do not alter class names or the color scheme. Update the header .sub
date to today, then place today's article first followed by up to 5 prior articles.

## 5 — Today's edition block
The photo grid holds 3 images, the stat grid holds 8 items, and the 7 topic sections follow in
this exact order: Cost of Living, Taxes on Retirement Income, Housing Market, Natural Disaster
Risk & Insurance, Sports Proximity, Senior Services & Community, Healthcare & Hospitals.

<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head"><span class="tag[ intl]">[US Destination|International Destination]</span> [Weekday], [Month] [D], [YYYY]</div>
<section class="dest-card">
<h2 class="dest-name">[City/Town]</h2>
<div class="dest-region">[County/State or Region, Country] &middot; [short geographic descriptor]</div>
<div class="photo-grid">
  <figure><img src="[IMG1]" alt="[alt]" loading="lazy" onerror="this.style.display='none'"><figcaption>[caption] &middot; <a href="[COMMONS1]" target="_blank" rel="noopener noreferrer">Wikimedia Commons</a></figcaption></figure>
  [two more figures]
</div>
<div class="stat-grid">
  <div class="stat-item"><span class="stat-label">Population</span><span class="stat-value">[figure]</span></div>
  <div class="stat-item"><span class="stat-label">65+ Population</span><span class="stat-value">[figure]</span></div>
  <div class="stat-item"><span class="stat-label">Climate</span><span class="stat-value">[short]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Mountains</span><span class="stat-value">[name &mdash; distance]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Beach</span><span class="stat-value">[name &mdash; distance]</span></div>
  <div class="stat-item"><span class="stat-label">Nearest Airport</span><span class="stat-value">[code &mdash; distance, routes]</span></div>
  <div class="stat-item"><span class="stat-label">Walk Score</span><span class="stat-value">[score]</span></div>
  <div class="stat-item"><span class="stat-label">Crime vs. National</span><span class="stat-value">[figure/trend]</span></div>
</div>
<h3 class="topic">Cost of Living</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Taxes on Retirement Income</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Housing Market</h3><p class="topic-summary">[3–5 sentences incl. the 2–3 bedroom trend, inline links]</p>
<h3 class="topic">Natural Disaster Risk &amp; Insurance</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Sports Proximity</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Senior Services &amp; Community</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
<h3 class="topic">Healthcare &amp; Hospitals</h3><p class="topic-summary">[3–5 sentences, inline links]</p>
</section>
</article>

Use class "tag intl" (both classes) with the label "International Destination" when IS_INTL is
true; otherwise class "tag" alone with "US Destination".

## 6 — Merge
Keep up to 5 prior editions. If the newest existing article already carries today's date,
replace it rather than prepending a duplicate.
MARK_jobs_retirement_md

echo "Updated:"
ls -1 jobs/art.md jobs/retirement.md
