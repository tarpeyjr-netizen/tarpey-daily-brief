# stock-analysis.html — Stock Analysis

Cadence: Mondays. History: NONE — this is a snapshot page, fully replaced each run. No
<article class="edition"> blocks and no merge step. Roster: none.

Two sections: the Beat & Trim tracker, then Upcoming Earnings for the next 5 business days.

## Gate
None. Runs every Monday.

## 0 — Efficiency
Do not read CLAUDE.md, About Me folders, or any unrelated file. Run searches in parallel
batches. No article scraping beyond what is needed to confirm a figure.

## 1 — Beat & Trim, trailing 6 months
S&P 500 / large-cap US stocks that in the trailing 6 months (a rolling window, recomputed
fresh each run) reported quarterly earnings that BEAT analyst estimates on EPS and/or revenue
but SIMULTANEOUSLY cut, lowered or trimmed forward guidance.

Search with queries like "beat earnings lowered guidance", "beats estimates cuts outlook",
"earnings beat guidance cut", "trims full-year guidance", combined with "S&P 500" or
"large cap". Vary the queries across sources (Reuters, Bloomberg, CNBC, Barron's, Seeking
Alpha, Yahoo Finance, MarketWatch) and across months within the window.

BOTH conditions must be verified for every candidate:
(a) EPS or revenue beat consensus for that quarter, AND
(b) forward guidance — next quarter or full year — was lowered relative to prior guidance.

Exclude beat-only, cut-only, and ambiguous cases. Guidance merely reaffirmed or in-line is NOT
a trim. If sources conflict or both conditions cannot be confirmed cleanly, leave the stock
out rather than guess.

Per qualifying stock record: report date, the beat (metric and magnitude if available), the
guidance change (old vs new range if available).

Then three price points via WebSearch ("[ticker] stock 52 week high", "[ticker] stock price
[report date]", "[ticker] stock price today"):
- 52-week high, current
- Post-trim price — the close within 1–2 trading days after the guidance-cut report
- Current price — latest available quote

These are news-search-derived, not live quotes. The page says so in its note; keep that note.
Prefix approximate figures with "≈".

Sort by report date, most recent first. If nothing qualifies, still render the section with its
empty-state row rather than omitting it.

## 2 — Upcoming earnings, next 5 business days
S&P 500 / large-cap US stocks scheduled to report within the next 5 business days. Compute
today and skip weekends with `date +%F` and `date +%u`.

Search "earnings calendar this week S&P 500", "companies reporting earnings [date range]",
named large caps known to be in the current season, and finance-site earnings calendars
(Nasdaq, Yahoo Finance, Zacks, MarketBeat, TipRanks).

Per company record: ticker, company name, scheduled report date, before-market-open (BMO) or
after-market-close (AMC) timing when available, and the consensus EPS estimate when readily
available.

Sort by report date ascending, then alphabetically by ticker within a date. Aim for roughly
10–30 names depending on how busy the week is. Do not pad with small or mid caps. A quiet week
is fine — show what is there, or the empty-state row.

## 3 — Page shell
Build stamp first line, above the doctype. Do not alter CSS variables or class names.
Inside <main class="wrap">: one <div class="asof"> with today's date, then Beat & Trim, then
Upcoming Earnings, then the disclaimer.

<!-- build: BUILD_ID -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Stock Analysis — The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --green:#0a7d2c; --red:#c0271a; --gray:#888; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:1000px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:30px 24px 26px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:14px; }
  .back:hover { color:#fff; }
  header h1 { font-size:25px; font-weight:700; letter-spacing:-0.3px; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:28px 24px 56px; }
  .asof { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:14px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:22px 24px; margin-bottom:20px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:12px; }
  .tablescroll { overflow-x:auto; }
  table { border-collapse:collapse; width:100%; font-size:13px; border:1px solid #cccccc; }
  thead th { background:var(--navy); color:#fff; font-weight:bold; padding:10px 10px; border:1px solid #cccccc; text-align:center; }
  thead th.l { text-align:left; }
  tbody td { padding:8px 10px; border:1px solid #e0e0e0; vertical-align:top; }
  tbody tr:nth-child(odd) { background:#fff; }
  tbody tr:nth-child(even) { background:#f4f6fa; }
  td.tk { font-weight:bold; }
  td.num { text-align:right; white-space:nowrap; }
  td.ctr { text-align:center; }
  .pos { color:var(--green); font-weight:600; }
  .neg { color:var(--red); font-weight:600; }
  .note { font-size:12px; color:var(--muted); margin-top:10px; }
  .empty { font-size:14px; color:var(--muted); padding:10px 0; }
  .disc { font-size:13px; color:var(--muted); font-style:italic; }
  .tag-bmo { display:inline-block; padding:1px 6px; border-radius:8px; font-size:11px; font-weight:bold; background:#e0e7ef; color:var(--navy); }
  .tag-amc { display:inline-block; padding:1px 6px; border-radius:8px; font-size:11px; font-weight:bold; background:#1f3a5f; color:#fff; }
</style>
</head>
<body>
<header>
  <div class="wrap">
    <a class="back" href="index.html">&larr; Back to dashboard</a>
    <h1>Stock Analysis</h1>
    <div class="sub">Beat-and-trim tracker plus the week ahead's large-cap earnings calendar</div>
  </div>
</header>
<main class="wrap">
  <div class="asof">As of [TODAY LONG DATE]</div>
  <section>
    <h2>Beat &amp; Trim — Trailing 6 Months</h2>
    <div class="tablescroll"><table>
      <thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Report Date</th><th class="l">What Beat</th><th class="l">What Got Trimmed</th><th>52-Wk High</th><th>Post-Trim Price</th><th>Current Price</th></tr></thead>
      <tbody>[one tr per qualifying stock, most recent first, OR <tr><td colspan="8" class="empty">No qualifying beat-and-trim reports found in the trailing 6 months as of this run.</td></tr>]</tbody>
    </table></div>
    <p class="note">Prices are news-search-derived approximations (52-week high, price shortly after the guidance-cut report, and latest available quote), not live market data &mdash; treat as directional. &asymp; indicates an approximate or estimated figure.</p>
  </section>
  <section>
    <h2>Upcoming Earnings — Next 5 Business Days</h2>
    <div class="tablescroll"><table>
      <thead><tr><th class="l">Ticker</th><th class="l">Company</th><th>Report Date</th><th>Timing</th><th>Consensus EPS Est.</th></tr></thead>
      <tbody>[one tr per company: <td class="tk">TICKER</td><td>Company</td><td class="ctr">YYYY-MM-DD</td><td class="ctr"><span class="tag-bmo">BMO</span>|<span class="tag-amc">AMC</span>|plain text</td><td class="num">$X.XX or n/a</td>. OR <tr><td colspan="5" class="empty">No large-cap earnings reports scheduled in the next 5 business days.</td></tr>]</tbody>
    </table></div>
    <p class="note">Earnings dates are subject to change; confirm with the company's investor relations page before acting on them.</p>
  </section>
  <section><p class="disc">This is not financial advice. Do your own research.</p></section>
</main>
<footer style="text-align:center;font-size:12px;color:#6a7280;padding:24px;">The Daily Brief &middot; Stock Analysis</footer>
<script>document.querySelectorAll('main a[href]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>

## 4 — index.html
Do NOT modify index.html. The dashboard card for this page already exists.
