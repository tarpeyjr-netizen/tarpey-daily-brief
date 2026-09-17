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
