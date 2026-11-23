# industry-intel.html — Weekly Industry Intel

Cadence: Mondays. History: rolling 4 weekly editions (today + prior editions 7–27 days old).
Roster: jobs/rosters/industry-intel.csv (group,name,notes), synced from the Google Sheet
"Tarpey Roster — Industry Intel" by jobs/_roster-sync.md. Edit the Sheet, not the CSV.
  group = consulting  → firms for section 2 (consulting news)
  group = hiring_firm → firms for section 1 (role openings and hiring signals)
  group = defense     → companies for section 2 (defense and client-sector news)
  group = platform    → platforms for section 3 (independent work)

Reader: a senior SAP S/4HANA program and transformation leader at a large SI, working in
A&D and Life Sciences, based in the Triangle area of North Carolina. Plain, direct prose. No
flattery, no hype. Every factual claim gets an inline source link.

DISCRETION: the site is reachable by link. Do not use the words "job search", "job hunt",
"leaving" or "my next role" anywhere on the page. Section and page names are fixed below.

## Gate
None. Runs every Monday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run searches in parallel
batches. "This week" is the 7 days ending yesterday; compute it with `date`.
Read jobs/rosters/industry-intel.csv first. A missing or unreadable CSV is a FAILED page.

## 1 — Role Market Watch
### 1a — Open roles
Find senior roles posted or re-posted in the last 14 days that match ALL of:
- Level: Director, Senior Director, Senior Manager, Principal, Managing Director, Partner,
  Vice President, Program Director, Delivery Executive, Practice Lead.
- Focus: SAP S/4HANA (RISE, GROW, brownfield / greenfield / selective conversion), ERP or
  business transformation, or large program / portfolio leadership.
- Location: fully remote US, OR Raleigh / Durham / Research Triangle Park / Cary / Chapel
  Hill (hybrid or on-site). Travel-heavy roles are fine. EXCLUDE any role that requires
  relocation, and any role based only in another metro with no remote option.
- Employer: any hiring_firm in the roster, OR an industry company (A&D, Life Sciences,
  manufacturing) hiring a client-side SAP program leader. NEVER list Capgemini openings.

Search firm career sites and aggregators: "[firm] SAP S/4HANA director remote", "SAP
transformation program director remote", "S/4HANA program director Raleigh", plus LinkedIn
Jobs, Indeed, Dice, Built In and company careers pages via WebSearch. Job boards often block
fetching; a listing is acceptable from search results only when the result shows title,
employer and location. Never invent a listing, a salary or a posted date.

Per role, one table row: Title (linked) | Employer | Location | Posted (date, or "not shown")
| Salary (only if published, else —).
Mark a row NEW when it did not appear in the previous edition on this page (compare title +
employer against the prior edition's table). Sort NEW first, then by posted date, newest
first. Aim for 8–20 rows. Fewer is fine; say so. Use an empty-state row if nothing qualifies.

### 1b — Hiring signals
Three to six bullets from the 7-day window: SAP practice expansions or cuts at hiring_firm
entries, SAP-focused acquisitions, large S/4HANA program wins that imply staffing up, senior
SAP leaders changing firms, and changes to SAP's partner program or RISE incentives. Each
bullet: what happened, why it matters for senior SAP hiring, source link.

## 2 — Consulting & Defense Intel
### 2a — Consulting firms
One short block per consulting entry. Cover the 7-day window only: deals and acquisitions,
layoffs or hiring freezes, leadership moves, earnings or guidance, and wins in Aerospace &
Defense or Life Sciences. If a firm had nothing material, write "No material news this
week." Do not pad with older items. 40–100 words per firm.

### 2b — Defense & client sectors
- Boeing and United Launch Alliance: program news, contracts, launches, leadership, labor,
  financials, ERP or digital-transformation news.
- DFARS: new or proposed rules, DFARS Change Notices, class deviations and final rules.
  Check acquisition.gov DFARS change notices, the Federal Register (DoD / DARS), and the
  Defense Pricing, Contracting and Acquisition Policy (DPCAP) site.
- Interchangeability: changes to parts interchangeability and substitution rules (DFARS,
  MIL-STD / MIL-HDBK, FAA). Report only actual rule or standard changes.
- Defense budget: NDAA progress, appropriations, continuing resolutions, and budget-request
  changes affecting space, aircraft or sustainment.
For each item: one or two sentences, why it matters to an SAP A&D program (cost accounting,
compliance, master data, MRO), source link. Quiet categories say so in one line.

## 3 — Independent Work
- Platforms: for each group=platform entry, report only real changes in the 7-day window
  (new SAP or AI-consulting demand, fee changes, new expert-network programs). Collapse
  platforms with no news into one line: "No changes: A, B, C."
- Demand: 2–4 bullets on freelance / fractional SAP and AI-consulting demand this week, with
  source links (surveys, platform reports, credible news).
- Rates: a small table of published rates for freelance or fractional SAP S/4HANA program /
  architect work and AI consulting (hourly or day rate, source, date). Only rates a source
  states; never estimate. If no new rate data appeared this week, carry forward the previous
  edition's table and label it "Unchanged from [date]".
- Claude-built tools: 2–3 examples from the window of people making money from tools built
  with Claude (MCP servers, Claude Code plugins or skills, paid templates, micro-SaaS), with
  how they charge and a link.

## 4 — Claude & Automation Playbook
PURPOSE: a short weekly answer to "what new Claude capability could I put to use this week,
and how?" The reader is a power user, not a developer. The reader uses Claude through the claude.ai
app, the desktop app (Chat, Cowork and Code tabs), scheduled routines, and connectors
(Google Drive, Gmail, Google Calendar), builds automations like this Daily Brief, uses
Claude for SAP program deliverables (workshop decks, RAID logs, org charts, status reports),
and is looking for side-income ideas. Write for this reader in plain English.

### What counts
New or changed, in the 7-day window, AND something a user (not a programmer) can turn on or use:
- Features in the Claude apps: chat, projects, artifacts, memory, research, file creation
  (decks, docs, spreadsheets), voice, mobile, Cowork, desktop Code tab.
- Automation: routines and scheduled tasks, triggers, agents working in the background.
- Connectors and integrations: new connectors, new abilities in existing ones (Drive, Gmail,
  Calendar, Slack, Microsoft 365, and others), browser and computer use.
- Skills and plugins: new skills, plugin marketplaces, notable new published plugins.
- Plan and limit changes that change what is practical (usage caps, new plan features).

### What does NOT count — leave it out
- Developer-only changes: CLI flags, slash-command internals, hook settings, SDK and API
  parameters, version-numbered changelog lines, bug fixes, performance tweaks.
- Company news (funding, IPO, hires, policy, safety research) and industry AI news; the AI
  Developments page covers those.
A Claude Code change counts only when a non-programmer would notice and use it.

### Sources
Anthropic news (anthropic.com/news), Claude app release notes (support.claude.com release
notes), the Claude blog (claude.com/blog), the connectors and plugin directories, and
credible coverage (The Verge, TechCrunch, Ars Technica) or practitioner write-ups (newsletters,
blog posts) showing how people use a new feature. Use the Claude Code changelog only to confirm
a user-visible feature, never as the source of an item on its own.

Reddit: r/ClaudeAI, r/ClaudeCode and r/Anthropic. Find posts with WebSearch, for example
"site:reddit.com/r/ClaudeAI workflow", "site:reddit.com/r/ClaudeCode routine", or
"site:reddit.com/r/ClaudeAI new feature". Fetching reddit.com may be blocked; search results
are enough when they show the post and its counts.
- Threshold: use a Reddit post only if it has at least 10 upvotes OR at least 10 comments.
  If neither count can be confirmed from the search result or the page, skip the post.
- Pattern of the week may come from Reddit alone. A post does not need setup detail; an
  interesting idea is enough. Write what the idea is and note the upvote/comment count.
- Feature items: Reddit can surface a feature, but each feature item still needs an official
  source or credible press coverage. Without one, leave the feature out.

### Format
2–4 feature items, then one "Pattern of the week". Fewer is fine. If nothing qualifying
shipped, write one line: "Quiet week for user-facing Claude features." and still include the
pattern.

Each feature item, about 60–90 words:
- **[Feature name]**, then one or two plain sentences on what it does, with no jargon. If a
  term like "connector" or "routine" is needed, it is fine; anything more technical gets a
  short explanation.
- *Why it matters to you:* one sentence tied to the reader's actual work.
- *Try this:* one concrete, doable idea, with effort shown as (10 min), (an hour) or (an
  afternoon). Example of the right altitude: "Have the Friday routine read the week's RAID
  log from Drive and email you the five overdue items (an hour)." Not right: anything that
  needs writing code, editing config files, or setting up hooks.
- Source link.

Pattern of the week, about 80–120 words: one way other people are using Claude, from a
practitioner write-up, credible coverage, or a Reddit post that meets the threshold, in the
last 30 days, that this reader could copy for work, the Daily Brief, or side income. Say what
they do, what it saves or earns if stated, and a first step to try it. Source link; for Reddit,
add the counts, e.g. "(r/ClaudeAI, 240 upvotes, 58 comments)".

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Weekly Industry Intel &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --new:#1d7a46; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 16px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 16px 56px; }
  nav.toc { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:20px; }
  nav.toc a { font-size:13px; background:#fff; border:1px solid var(--line); border-radius:999px; padding:5px 12px; text-decoration:none; color:var(--navy); }
  article.edition { margin-bottom:32px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:20px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 20px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; color:var(--ink); margin:20px 0 6px; padding-top:16px; border-top:1px solid var(--line); }
  h2 + h3 { margin-top:0; padding-top:0; border-top:none; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; margin-bottom:8px; }
  li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  .tbl { overflow-x:auto; margin-bottom:8px; }
  table { width:100%; border-collapse:collapse; font-size:13px; }
  th, td { text-align:left; padding:7px 8px; border-bottom:1px solid var(--line); vertical-align:top; }
  th { font-size:12px; text-transform:uppercase; letter-spacing:.4px; color:var(--muted); }
  .new { display:inline-block; font-size:10.5px; font-weight:700; color:#fff; background:var(--new); border-radius:4px; padding:1px 5px; margin-right:4px; }
  .note { font-size:12.5px; color:var(--muted); }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Weekly Industry Intel</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 4 weeks</div>
</div></header>
<main class="wrap">
<nav class="toc"><a href="#consulting">Consulting &amp; Defense</a><a href="#roles">Role Market</a><a href="#independent">Independent Work</a><a href="#playbook">Claude Playbook</a></nav>
[TODAY'S EDITION]
[PRIOR EDITIONS 7–27 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Weekly Industry Intel</footer>
<script>document.querySelectorAll('main a[href^="http"]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 6 — Today's edition block
Section order on the page is fixed: Consulting & Defense Intel, Role Market Watch,
Independent Work, Claude & Automation Playbook. Research may run in any order.
Only the newest edition carries the section ids (roles, consulting, independent, playbook).
When merging, strip the id attributes from prior editions so ids stay unique.

<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week of [Month D, YYYY]</div>
<section id="consulting">
<h2>🏢 Consulting &amp; Defense Intel</h2>
<h3>[Firm]</h3><p>[block]</p>
[repeat per consulting firm]
<h3>Boeing &amp; ULA</h3><ul>[items]</ul>
<h3>DFARS &amp; interchangeability</h3><ul>[items]</ul>
<h3>Defense budget</h3><ul>[items]</ul>
</section>
<section id="roles">
<h2>💼 Role Market Watch</h2>
<h3>Open roles</h3>
<div class="tbl"><table>
<tr><th>Role</th><th>Employer</th><th>Location</th><th>Posted</th><th>Salary</th></tr>
<tr><td><span class="new">NEW</span><a href="[url]">[Title]</a></td><td>[Employer]</td><td>[Location]</td><td>[Date]</td><td>[Published range or —]</td></tr>
</table></div>
<p class="note">Remote US or Triangle NC only; relocation-required roles excluded. Listings come from search results and career pages. Confirm on the employer's site before applying.</p>
<h3>Hiring signals</h3>
<ul>[bullets]</ul>
</section>
<section id="independent">
<h2>💡 Independent Work</h2>
<h3>Platforms</h3><ul>[items]</ul>
<h3>Demand</h3><ul>[items]</ul>
<h3>Rates</h3><div class="tbl"><table><tr><th>Work type</th><th>Rate</th><th>Source</th><th>Date</th></tr>[rows]</table></div>
<h3>Claude-built tools making money</h3><ul>[items]</ul>
</section>
<section id="playbook">
<h2>⚙️ Claude &amp; Automation Playbook</h2>
<h3>[Feature name]</h3>
<p>[What it does, plain English.]</p>
<p><strong>Why it matters to you:</strong> [one sentence]</p>
<p><strong>Try this:</strong> [concrete idea] <span class="note">([effort])</span> &middot; <a href="[url]">Source</a></p>
[repeat per feature item]
<h3>Pattern of the week: [short title]</h3>
<p>[what people do, what it saves or earns, first step] <a href="[url]">Source</a></p>
</section>
</article>

## 7 — index.html
Do NOT modify index.html. The dashboard card for this page already exists.

## 8 — Merge
Keep prior editions dated 7–27 days before today (the three previous Mondays). A same-day
re-run replaces today's edition. If the existing page has no edition blocks (the initial
placeholder), publish today's edition alone.
