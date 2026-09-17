# stocks.html — Weekly Stock Report

Cadence: Fridays. History: rolling 8-day window (today + prior editions 1–7 days old), so the
page shows the two most recent weekly editions.
Roster: jobs/rosters/stocks.csv (ticker,company,notes)

## Gate
None. Runs every Friday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run searches in parallel
batches. Headlines are one line, 140 characters max. No long quotes, no article scraping.

## 1 — Tickers
Read jobs/rosters/stocks.csv from the clone and cover every ticker. The notes column carries
special handling: BTC is spot USD; SPCX also gets its own News section. No fallback list and no
warning banner. A missing or unreadable CSV is a FAILED page.

## 2 — Data to gather, in parallel batches
1. 3–5 USA economic headlines from the past 7 days.
2. 3–5 global economic headlines from the past 7 days.
3. Per ticker: current price; 1W, 1M and 1Y return %; 1–2 headlines from the past 7 days;
   a Buy/Sell/Hold call with a one-sentence rationale.
   BTC is spot USD. Where an exact 1Y return is unavailable, estimate against the price about
   52 weeks ago and prefix the figure with "≈".
4. SpaceX: 1–3 notable headlines from the past 7 days.
5. One additional stock idea outside the list: name, ticker, two-sentence thesis.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.
Positive percentages go in <span class="pos">, negative in <span class="neg">. Recommendation
pills use b-buy / b-sell / b-hold. Prefix approximate figures with "≈".

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Weekly Stock Report — The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --green:#0a7d2c; --red:#c0271a; --gray:#888; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:900px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  .back:hover { color:#fff; }
  header h1 { font-size:25px; font-weight:700; letter-spacing:-0.3px; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  article.edition { margin-bottom:32px; }
  article.edition + article.edition { border-top:3px solid var(--navy); padding-top:20px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  ul { padding-left:20px; }
  li { font-size:14px; line-height:1.6; margin-bottom:5px; }
  .tablescroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:13.5px; border:1px solid #cccccc; }
  thead th { background:var(--navy); color:#fff; font-weight:bold; padding:10px 12px; border:1px solid #cccccc; text-align:center; }
  thead th.l { text-align:left; }
  tbody td { padding:8px 12px; border:1px solid #e0e0e0; }
  tbody tr:nth-child(odd) { background:#fff; }
  tbody tr:nth-child(even) { background:#f4f6fa; }
  td.tk { font-weight:bold; }
  td.num { text-align:right; }
  td.ctr { text-align:center; }
  .pos { color:var(--green); font-weight:600; }
  .neg { color:var(--red); font-weight:600; }
  .pill { display:inline-block; padding:2px 8px; border-radius:10px; font-size:12px; font-weight:bold; color:#fff; }
  .b-buy { background:var(--green); } .b-sell { background:var(--red); } .b-hold { background:var(--gray); }
  .note { font-size:12px; color:var(--muted); margin-top:10px; }
  .stock { margin-bottom:16px; padding-bottom:14px; border-bottom:1px solid var(--line); }
  .stock:last-child { border-bottom:0; margin-bottom:0; padding-bottom:0; }
  .stock .hd { font-weight:700; font-size:14.5px; }
  .stock .rat { font-size:14px; margin:3px 0 5px; }
  .stock ul { margin-top:4px; }
  .stock li { font-size:13px; color:#444; }
  .disc { font-size:13px; color:var(--muted); font-style:italic; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px; }
</style>
</head>
<body>
<header>
  <div class="wrap">
    <a class="back" href="index.html">&larr; Back to dashboard</a>
    <h1>Weekly Stock Report</h1>
    <div class="sub">Latest: week of [MON DATE] &ndash; [FRI DATE], [YYYY] &middot; showing the last 8 days</div>
  </div>
</header>
<main class="wrap">
[TODAY'S EDITION]
[PRIOR EDITIONS 1–7 DAYS OLD]
</main>
<footer>The Daily Brief &middot; Weekly Stock Report</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — Today's edition block
<article class="edition" data-date="[TODAY ISO]">
<div class="ed-head">Week of [MON DATE] &ndash; [FRI DATE], [YYYY] &middot; generated [GENERATED DATE]</div>
<section><h2>USA Economic Headlines</h2><ul>[3–5 <li>]</ul></section>
<section><h2>Global Economic Headlines</h2><ul>[3–5 <li>]</ul></section>
<section>
<h2>Portfolio Stock Performance</h2>
<div class="tablescroll"><table>
<thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Price</th><th>1W %</th><th>1M %</th><th>1Y %</th><th>Rec</th></tr></thead>
<tbody>[one tr per ticker: <td class="tk">TICKER</td><td>Company</td><td class="num">$Price</td><td class="num"><span class="pos|neg">±X%</span></td> ×3 <td class="ctr"><span class="pill b-buy|b-hold|b-sell">Buy|Hold|Sell</span></td>]</tbody>
</table></div>
<p class="note">≈ indicates an approximate or estimated figure where an exact period return was not available. Prices reflect the most recent close/quote. CGEMY ADR price estimated from the Euronext Paris listing.</p>
</section>
<section>
<h2>Stock Notes &amp; Headlines</h2>
[per ticker: <div class="stock"><div class="hd">TICKER &mdash; Company</div><div class="rat"><span class="pill b-buy|b-hold|b-sell">Buy|Hold|Sell</span> &nbsp;One-sentence rationale.</div><ul><li>headline</li></ul></div>]
</section>
<section><h2>SpaceX News</h2><ul>[1–3 <li>]</ul></section>
<section><h2>New Stock to Consider</h2><p style="font-size:14px;line-height:1.6;"><b>Name (TICKER)</b> &mdash; [two-sentence thesis]</p></section>
<section><p class="disc">This is not financial advice. Do your own research.</p></section>
</article>

## 5 — Merge
Keep prior editions dated 1–7 days before today.
