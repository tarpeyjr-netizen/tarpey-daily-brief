# ai.html — AI Developments

Cadence: every day. History: rolling 8-day window (today + prior editions 1–7 days old).
Roster: jobs/rosters/ai-tools.csv (tool,day_of_week) — two tools per day.

## Gate
None. Runs every day.

## 1 — Today's tools
Read jobs/rosters/ai-tools.csv from the clone and select every row whose day_of_week matches
today's weekday name. No fallback schedule, no roster warning banner. A missing or unreadable
CSV is a FAILED page.

## 2 — Writing style — STRICTLY ENFORCED
Each tool section is a flowing "This Week in [Tool]" magazine article — 3–4 paragraphs of
connected prose, no bullet points. Tone: a smart, enthusiastic journalist writing for a curious
15-year-old. Conversational, plain English, short sentences, real-world analogies, zero
corporate speak. Paragraphs flow into each other. Cover the 3–5 most significant developments
woven into a narrative, not listed separately. If it was a quiet week, say so warmly in a short
paragraph and note the last interesting thing that happened.

## 3 — Research
Cutoff: python3 -c "import datetime; print((datetime.date.today()-datetime.timedelta(days=7)).strftime('%Y-%m-%d'))"

Two searches per tool:
1. "[Tool] news update announcement after:CUTOFF"
2. "[Tool] new features release after:CUTOFF"

Take the 3–5 most interesting developments per tool from the past 7 days. If genuinely nothing
in 7 days, broaden to 14 and note it was a quiet week.

## 4 — Tool Spotlight — Wednesdays and Saturdays only
After the scheduled tools, pick ONE AI tool, product or model that is NOT in ai-tools.csv, has
had a notable release or moment in the last 2 weeks, and is genuinely interesting. Search
"new AI tool announcement [current week]" or "AI model release [current month year]".
Write 150–200 words of prose: what it is, what it does, why it matters, who would use it, and
anything surprising. Title the section "🔍 Tool Spotlight: [Tool Name]".

## 5 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>AI Developments &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --ai-accent:#7c3aed; }
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
  .tool-chip { display:inline-block; font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:.7px; padding:3px 10px; border-radius:20px; margin-bottom:12px; background:#ede9fe; color:#5b21b6; }
  .spotlight-chip { background:#fef3c7; color:#92400e; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  section.spotlight { border-left:4px solid var(--ai-accent); }
  h2 { font-size:18px; color:var(--navy); margin-bottom:10px; }
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
<h1>AI Developments</h1>
<div class="sub">Latest: [Month D, YYYY] &middot; tools &middot; releases &middot; breakthroughs &middot; what it means for you</div>
</div></header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; AI Developments &middot; Updated daily at 4 AM</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 6 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">AI Developments &mdash; [Day of Week], [Month D, YYYY]</div>
[one section per tool scheduled today:]
<section>
<span class="tool-chip">[Tool]</span>
<h2>This Week in [Tool]</h2>
<p>[Opening: 1–2 sentences of plain-English context on what the tool is, flowing straight into the week's news.]</p>
<p>[Middle: the week's 3–5 developments woven into connected prose — what happened, why it matters, what it feels like in practice.]</p>
<p>[Closing: a brief forward-looking "so what".]</p>
[quiet week instead: <p class="quiet">Quiet week for [Tool] — no major announcements in the past seven days. The last notable move was [brief note].</p>]
</section>
[Wednesdays and Saturdays only:]
<section class="spotlight">
<span class="tool-chip spotlight-chip">🔍 Tool Spotlight</span>
<h2>[Tool Name]</h2>
<p>[150–200 words of flowing prose, no bullets, teen-friendly.]</p>
<p class="muted">Source: [Source Name, Month YYYY]</p>
</section>
</article>

## 7 — Merge
Keep prior editions dated 1–7 days before today.
