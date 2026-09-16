# sap-migration.html — SAP Migration Tools Intel

Cadence: Tuesdays. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/sap-vendors.csv (tool_type,vendor)

## Gate
None. Runs every Tuesday.

## 1 — Vendor list
Read jobs/rosters/sap-vendors.csv from the clone. Group vendors into sections by tool_type, in
the order the types first appear in the file. No fallback list. A missing or unreadable CSV is
a FAILED page.

A vendor may appear under more than one tool_type (Syniti is under both Data Migration and Data
Management). Cover it fully once, under the first type it appears in, and reference it briefly
under the other.

Do not read CLAUDE.md, About Me folders, or any unrelated file.

## 2 — Research, per vendor
Parallel WebSearch where possible. For each vendor gather:

1. **Quick overview** — one or two sentences on what the vendor's SAP migration tool does and
   its market position.
2. **Press releases within the last 10 days** — news dated inside that exact window. If there
   is nothing, say so explicitly rather than substituting older news. You may separately
   mention the most recent notable older item for context, clearly labeled as outside the
   10-day window.
3. **New product developments** — recent feature releases, roadmap announcements, partnerships,
   platform updates. Need not be within 10 days, but should be recent (2026).
4. **How it uses AI** — only when AI/ML/agentic capability actually came up in research.

### The AI paragraph — the standard is mechanism, not adjective
Do NOT write "AI-powered" or "AI-driven" and move on. Search for what the AI actually does.
Good: "parses ABAP into a meta-model and applies AI-driven rules to flag code eligible for
reversion to standard"; "visually recognizes UI elements via CNNs so tests self-heal when
screens change"; "an agent that turns natural-language requests into structured data changes".
If a vendor's AI claim is vague marketing language with no confirmable mechanism, say that
plainly rather than inventing specifics. Skip the paragraph entirely for vendors where AI did
not come up.

### Unverifiable vendors
If a vendor name cannot be confidently matched to a real company — search returns only
unrelated companies with similar names — say so plainly instead of guessing or fabricating,
and note that it should be double-checked.

Length: roughly 60–150 words per vendor across all parts, more when an AI mechanism paragraph
applies. Include inline source links for verifiable claims.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>SAP Migration Tools Intel &mdash; The Daily Brief</title>
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
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  h3 { font-size:15px; color:var(--ink); margin:22px 0 4px; padding-top:18px; border-top:1px solid var(--line); }
  h2 + h3 { margin-top:0; padding-top:0; border-top:none; }
  p { font-size:14px; line-height:1.6; margin-bottom:8px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:6px; }
  a { color:#1f5fae; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; border-top:1px solid var(--line); }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>SAP Migration Tools Intel</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; showing the last 8 days</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; SAP Migration Tools Intel</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
One <section> per tool type. The CSS already draws a divider above each vendor's <h3> except
the first in a section — do not add <hr> tags or blank paragraphs for spacing.

<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">SAP Migration Tools Intel &mdash; Week of [Month D, YYYY]</div>
<section>
<h2>🔧 [Tool Type]</h2>
<h3>[Vendor]</h3>
<p>[Overview]</p>
<p><strong>Press releases (last 10 days):</strong> [findings, or "None found."]</p>
<p><strong>New product developments:</strong> [findings]</p>
<p><strong>How it uses AI:</strong> [mechanism-level detail — omit this paragraph entirely when AI did not come up]</p>
[repeat h3 block per vendor in this tool type]
</section>
[repeat section per tool type]
</article>

## 5 — index.html
Do NOT modify index.html. The dashboard card for this page already exists.

## 6 — Merge
Keep prior editions dated 1–7 days before today.
