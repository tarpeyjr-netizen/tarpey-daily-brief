# enterprise.html — Enterprise Software Intel

Cadence: Thursdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: none — the platform list is below.

## Gate
None. Runs every Thursday.

## Monthly supplement
Include the two Monthly Supplement sections ONLY on the first Thursday of the month:

  python3 -c "import datetime; d=datetime.date.today(); print(d.weekday()==3 and d.day<=7)"

Note: this page previously ran on Fridays and the supplement was keyed to the first Friday.
It now runs Thursdays and the gate is keyed to the first Thursday. Do not reintroduce a Friday
check — on a Thursday routine it would never fire.

## 1 — Research
WebSearch each section, in parallel where possible. Prioritize results from the past 7 days.
Keep the whole digest under about 1,400 words.

### Platform News — each platform gets its own <h3>
SAP sub-products, covered individually (search each by name + "2026"):
- **S/4HANA** — core ERP, cloud vs on-prem, migrations, the 2027 ECC deadline
- **Joule** — agents, Joule Studio, Joule Work
- **SAP Analytics Cloud** — BI, planning, predictive
- **SAP Integration Suite** — middleware, APIs, MCP/event mesh
- **SAP Build** — Build Apps, Build Work Zone, Build Process Automation (low-code)
- **WalkMe** — digital adoption, quarterly release
- **Signavio** — process intelligence, process mining
- **LeanIX** — enterprise architecture management, IT portfolio management, application
  rationalization, tech landscape mapping, cloud transformation planning
- **BTP** — Business Technology Platform, Business AI Platform
- **IBP** — Integrated Business Planning, supply chain
- **BRIM** — Billing & Revenue Innovation Management
- **Cloud ALM** — application lifecycle management

Where a sub-product has no news, note what to watch and where to monitor rather than padding.

Then one substantive paragraph each: **Salesforce**, **ServiceNow**, **Workday**,
**Microsoft 365**, **Databricks** (Data Intelligence Platform, Unity Catalog, Mosaic AI,
LakeFlow, and any enterprise data/AI announcements).

### AI in the Enterprise
Notable enterprise AI deployments and product updates (Copilot, Einstein, Now Assist, Joule),
plus one honest hype-vs-reality take. Search "enterprise AI deployment 2026" and
"enterprise AI product update 2026".

### Implementation Wins & Losses
Go-lives, case studies, failed rollouts, cost overruns. Name companies and systems. Search
"ERP implementation failure 2026", "Salesforce go-live 2026", "SAP go-live 2026".

### Threats & Risks
Security incidents on enterprise platforms, vendor lock-in stories, market shifts,
consolidation. Search "enterprise software security incident 2026", "vendor lock-in 2026".

### YouTube Picks
2–3 recent videos from enterprise channels (SAP Learning, Salesforce Developers, ServiceNow
Community, Workday, Microsoft Mechanics, Gartner). Title, channel, URL, and one sentence on
why it is worth watching.

### Training & Certification Finds
New courses, free resources, exam changes, new or retiring certs across SAP, Salesforce,
ServiceNow, Workday, Microsoft.

### Monthly supplement sections — first Thursday only
**Analyst Trend Roundup** — Gartner, Forrester, IDC reports or predictions published this
month. **Certification Landscape** — new certs launched, retiring certs, exam format changes
across all major platforms.

## 2 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Enterprise Software Intel &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --monthly-bg:#eef3fb; }
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
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  section.monthly { background:var(--monthly-bg); border-color:#c3d4ed; }
  .monthly-rule { border:none; border-top:2px solid var(--navy); margin:8px 0 20px; opacity:.25; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; color:var(--ink); margin:14px 0 4px; }
  h3:first-child { margin-top:0; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  .monthly-label { display:inline-block; font-size:11px; font-weight:700; letter-spacing:.4px; text-transform:uppercase; background:var(--navy); color:#fff; border-radius:4px; padding:2px 7px; margin-bottom:12px; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Enterprise Software Intel</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Enterprise Software Intel</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 3 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Enterprise Software Intel &mdash; Week of [Month D, YYYY]</div>
<section>
<h2>🏢 Platform News</h2>
[SAP sub-product <h3> blocks in the order listed above, each with <p> and inline source links]
[then <h3>Salesforce</h3>, <h3>ServiceNow</h3>, <h3>Workday</h3>, <h3>Microsoft 365</h3>, <h3>Databricks</h3>]
</section>
<section><h2>🤖 AI in the Enterprise</h2>[3–5 <li> bullets with source links]</section>
<section><h2>✅ Implementation Wins &amp; Losses</h2>[3–5 <li> bullets, company/system names bold]</section>
<section><h2>⚠️ Threats &amp; Risks</h2>[3–5 <li> bullets with source links]</section>
<section><h2>▶️ YouTube Picks</h2>[2–3 items: <h3><a href="[URL]">[Title]</a></h3><p><strong>[Channel]</strong> — [one sentence]</p>]</section>
<section><h2>🎓 Training &amp; Certification Finds</h2>[3–5 <li> bullets with links]</section>
[first Thursday of the month only:]
<hr class="monthly-rule">
<section class="monthly"><span class="monthly-label">Monthly Supplement</span><h2>📊 Analyst Trend Roundup</h2>[3–5 <li> bullets]</section>
<section class="monthly"><span class="monthly-label">Monthly Supplement</span><h2>📜 Certification Landscape</h2>[3–5 <li> bullets]</section>
</article>

## 4 — Merge
Keep prior editions dated 1–7 days before today.
