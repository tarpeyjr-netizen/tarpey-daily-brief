# science.html — Science Daily

Cadence: every day. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: none — the topic rotation is below.

## Gate
None. Runs every day.

## 1 — Today's topic
date +"%A"; python3 -c "import datetime; wk=datetime.date.today().isocalendar()[1]; print('WEEK_1' if wk%2==1 else 'WEEK_2')"

Odd ISO week = WEEK_1. Even ISO week = WEEK_2. This alternates automatically — never hardcode.

WEEK_1: Mon Space · Tue Physics · Wed Chemistry · Thu Biology · Fri Medicine · Sat Agriculture
WEEK_2: Mon Batteries & Electricity · Tue Oceanography · Wed Robotics & Engineering ·
        Thu Mathematics · Fri Epidemiology · Sat Neuroscience
Sunday (both weeks): LONG READ — different format, see section 3.

## 2 — Monday–Saturday
Cutoff: python3 -c "import datetime; print((datetime.date.today()-datetime.timedelta(days=7)).strftime('%Y-%m-%d'))"

2–3 searches on today's topic:
1. "[topic] discovery breakthrough research after:CUTOFF"
2. "[topic] study announcement [current month year]"
3. "new [topic] research news this week"

Take the 4–6 most interesting, significant or surprising developments from the past 7 days —
peer-reviewed studies, major discoveries, notable missions/trials/reports. Prefer primary
science journalism over press releases. If genuinely nothing in 7 days, broaden to 14 and note
it was a quiet week.

Write 3–4 connected paragraphs: an opening that frames what is interesting in the field and
flows into this week's news; a middle weaving the developments together with analogies; a
closing "so what" for a curious non-scientist.

## 3 — Sunday long read
Replaces the roundup format entirely, every Sunday, regardless of WEEK_1/WEEK_2.

Pick a category NOT among the twelve in the Mon–Sat rotations:

python3 -c "
import random, datetime
topics = ['Genetics & Genomics','Paleontology','Geology','Climate Science','Astrobiology','Quantum Computing','Materials Science','Cognitive Science & Psychology','Volcanology','Entomology','Immunology','Meteorology','Anthropology','Marine Biology','Nanotechnology','Sleep Science','Seismology','Evolutionary Biology','Exoplanets','Botany','Zoology','Microbiology','Renewable Energy Science','Cryobiology','Linguistics & the Science of Language']
random.seed(datetime.date.today().toordinal())
print(random.choice(topics))
"

Check the cloned science.html for recent repeats — the file is already in the clone:
  grep -o '<h2 class="longread-title">[^<]*</h2>' science.html
If today's pick clearly overlaps a headline from the last 4 editions, re-roll with a seed
offset (+1, +2, …) until it is fresh.

Within that category, 3–5 searches to find ONE specific compelling story, discovery,
phenomenon or open mystery — not a generic overview. Good: a single wild experiment, a strange
organism, an unsolved puzzle, a landmark discovery and its human story.

Write 600–900 words with a real narrative arc: hook, context, the science explained
accessibly, why it matters or what is still unknown, a memorable closing thought. No bullets,
no headers inside the prose. Same accessible plain-English voice as the daily sections.

## 4 — Writing style — STRICTLY ENFORCED
Flowing magazine prose. No bullet points, no listicles. A smart, curious science journalist
writing for an intelligent general reader who is not a specialist: plain-English explanations
of jargon, real-world analogies, genuine enthusiasm, zero corporate or press-release speak.
Weave developments into a narrative rather than listing them. If the week was quiet, say so
warmly and note the last genuinely interesting thing in that field.

## 5 — Topic chip colors (background / text)
Space #e0e7ff/#4338ca · Physics #dbeafe/#1d4ed8 · Chemistry #d1fae5/#047857 ·
Biology #ccfbf1/#0f766e · Medicine #fee2e2/#b91c1c · Agriculture #fef3c7/#92400e ·
Batteries & Electricity #fef9c3/#854d0e · Oceanography #cffafe/#0e7490 ·
Robotics & Engineering #e2e8f0/#334155 · Mathematics #fae8ff/#86198f ·
Epidemiology #ffe4e6/#9f1239 · Neuroscience #e9d5ff/#7e22ce · Sunday long read #ede9fe/#6d28d9

## 6 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Science Daily &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:32px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:20px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  .topic-chip { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; padding:3px 10px; border-radius:20px; margin-bottom:12px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  section.longread { border-left:4px solid #6d28d9; }
  h2 { font-size:18px; color:var(--navy); margin-bottom:10px; }
  h2.longread-title { font-size:21px; }
  p { font-size:14.5px; line-height:1.75; margin-bottom:12px; }
  p:last-child { margin-bottom:0; }
  .quiet { font-style:italic; color:var(--muted); font-size:13px; }
  .muted { color:var(--muted); font-size:13px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Science Daily</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; alternating weekly topics &middot; Sunday long read</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Science Daily &middot; Updated daily</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 7 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Science Daily &mdash; [Day of Week], [Month D, YYYY]</div>
[Mon–Sat:]
<section>
<span class="topic-chip" style="background:[BG];color:[TEXT]">[Topic]</span>
<h2>This Week in [Topic]</h2>
<p>[Opening]</p><p>[Middle]</p><p>[Closing "so what"]</p>
[quiet week: <p class="quiet">Quiet week for [Topic] — no major developments in the past seven days. The last notable finding was [brief note].</p>]
</section>
[Sunday instead:]
<section class="longread">
<span class="topic-chip" style="background:#ede9fe;color:#6d28d9">Sunday Long Read</span>
<h2 class="longread-title">[Feature Title]</h2>
<p class="muted">[Category]</p>
<p>[600–900 words in natural paragraphs]</p>
</section>
</article>

## 8 — Merge
Keep prior editions dated 1–7 days before today.
