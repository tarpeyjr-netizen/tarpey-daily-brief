#!/usr/bin/env python3
"""Fetch Concept2 rower results and write jobs/data/rowing-weekly.csv.
Meters = distance + rest_distance; minutes = (time + rest_time)/600 (matches Concept2's weekly summary).
Token is read from --token-file or env C2_TOKEN; never printed."""
import argparse, csv, datetime as dt, json, os, collections, urllib.request

def get(url, tok):
    req = urllib.request.Request(url, headers={"Authorization": "Bearer " + tok, "Accept": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def fetch(tok, start):
    rows, page = [], 1
    while True:
        d = get(f"https://log.concept2.com/api/users/me/results?type=rower&from={start}&number=250&page={page}", tok)
        rows += d["data"]
        pg = (d.get("meta") or {}).get("pagination") or {}
        if page >= pg.get("total_pages", 1): break
        page += 1
    return rows

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--token-file"); ap.add_argument("--out", required=True)
    ap.add_argument("--start"); ap.add_argument("--recent-days", type=int); ap.add_argument("--today", required=True)
    a = ap.parse_args()
    tok = os.environ.get("C2_TOKEN") or open(a.token_file).read().strip()
    t = dt.date.fromisoformat(a.today)
    start = a.start or (str(t - dt.timedelta(days=a.recent_days + t.weekday())) if a.recent_days else "2025-12-29")
    rows = fetch(tok, start)
    ids = {r["id"]: r for r in rows}  # dedupe
    w = collections.defaultdict(lambda: [0, 0])
    for r in ids.values():
        day = dt.date.fromisoformat(r["date"][:10])
        m = day - dt.timedelta(days=day.weekday())
        w[m][0] += (r["distance"] or 0) + (r.get("rest_distance") or 0)
        w[m][1] += ((r["time"] or 0) + (r.get("rest_time") or 0)) / 600
    with open(a.out, "w", newline="") as f:
        f.write("# Weekly rowing totals from the Concept2 logbook API (meters and minutes include rest).\n")
        f.write(f"# as_of: {a.today}\n")
        f.write("week_start,meters,minutes\n")
        for m in sorted(w):
            f.write(f"{m},{w[m][0]},{round(w[m][1],2)}\n")
    print(f"results={len(ids)} weeks={len(w)} -> {a.out}")
main()
