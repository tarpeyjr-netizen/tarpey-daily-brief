#!/usr/bin/env python3
"""Price points for stock-analysis.html, from Yahoo Finance daily history.

Usage:  python3 jobs/tools/quotes.py TICKER:YYYY-MM-DD [TICKER:YYYY-MM-DD ...]
        (the date is the earnings report date)

Prints one CSV row per ticker:
  ticker,report_date,high_52w,high_52w_date,post_trim_close,post_trim_date,current,current_date,pct_since_trim,status

- high_52w        highest daily high in the trailing 12 months
- post_trim_close close of the first trading day AFTER the report date (reflects both
                  before-open and after-close reports)
- current         latest daily close in the series
- status          ok | partial: <what is missing> | error: <text>
A blank cell means the figure could not be computed. Never fill a blank by estimating.
"""
import csv, datetime, json, sys, time, urllib.request

URL = "https://query1.finance.yahoo.com/v8/finance/chart/{sym}?range=1y&interval=1d"
UA = {"User-Agent": "Mozilla/5.0", "Accept": "*/*"}   # a long browser UA string gets HTTP 429

def fetch(sym):
    last = ""
    for wait in (0, 6, 15):          # Yahoo rate-limits (HTTP 429): space the retries out
        time.sleep(wait)
        try:
            with urllib.request.urlopen(urllib.request.Request(URL.format(sym=sym), headers=UA), timeout=25) as r:
                return json.load(r)["chart"]["result"][0]
        except Exception as e:       # noqa: BLE001 - report whatever went wrong
            last = f"{type(e).__name__}: {e}"
    raise RuntimeError(last)

def row(arg):
    sym, _, rep = arg.partition(":")
    sym = sym.strip().upper()
    out = {"ticker": sym, "report_date": rep}
    try:
        res = fetch(sym.replace(".", "-"))
        q = res["indicators"]["quote"][0]
        off = res["meta"].get("gmtoffset", 0)
        days = [(datetime.datetime.fromtimestamp(t + off, datetime.timezone.utc).date(), h, c)
                for t, h, c in zip(res["timestamp"], q["high"], q["close"]) if c is not None]
        if not days:
            raise RuntimeError("no price rows returned")
        hd, hh, _ = max((d for d in days if d[1] is not None), key=lambda d: d[1])
        out.update(high_52w=f"{hh:.2f}", high_52w_date=hd.isoformat(),
                   current=f"{days[-1][2]:.2f}", current_date=days[-1][0].isoformat())
        missing = []
        try:
            rd = datetime.date.fromisoformat(rep)
            after = [d for d in days if d[0] > rd]
            if after and (after[0][0] - rd).days <= 6:
                out.update(post_trim_close=f"{after[0][2]:.2f}", post_trim_date=after[0][0].isoformat(),
                           pct_since_trim=f"{(days[-1][2] / after[0][2] - 1) * 100:+.1f}")
            else:
                missing.append("no trading day found right after the report date")
        except ValueError:
            missing.append("report date not YYYY-MM-DD")
        out["status"] = "ok" if not missing else "partial: " + "; ".join(missing)
    except Exception as e:           # noqa: BLE001
        out["status"] = f"error: {e}"
    return out

if __name__ == "__main__":
    cols = ["ticker", "report_date", "high_52w", "high_52w_date", "post_trim_close", "post_trim_date",
            "current", "current_date", "pct_since_trim", "status"]
    w = csv.DictWriter(sys.stdout, fieldnames=cols, lineterminator="\n")
    w.writeheader()
    for i, a in enumerate(sys.argv[1:]):
        if i:
            time.sleep(2)            # stay under Yahoo's rate limit
        w.writerow(row(a))
