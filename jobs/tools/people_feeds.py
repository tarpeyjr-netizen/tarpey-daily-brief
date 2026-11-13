#!/usr/bin/env python3
"""Pull each person's own feeds for people.html — no web search needed.

Usage:  python3 jobs/tools/people_feeds.py [DAYS]      (default 8, counted back from now)

Reads jobs/rosters/people.csv and jobs/rosters/people-sources.csv, fetches every feed once,
and prints, per person in roster order:

  ## <Person>
  FEED_ITEM | <YYYY-MM-DD> | <source> (<kind>) | <title> | <link> | <summary, 400 chars>
  FEED_QUIET | <source> | newest item <YYYY-MM-DD>          (feed read fine, nothing in window)
  FEED_FAILED | <source> | <url> | <error>                  (fetch the same url with WebFetch)
  NO_FEED                                                   (person has no row in people-sources.csv)

`match` in people-sources.csv is a regex for shared feeds: an item counts only when its
title, author or summary matches. Empty match = every item in the feed is this person's.
"""
import csv, datetime, email.utils, html, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DAYS = int(sys.argv[1]) if len(sys.argv) > 1 else 8
NOW = datetime.datetime.now(datetime.timezone.utc)
START = NOW - datetime.timedelta(days=DAYS)

def clean(s):
    s = re.sub(r"<!\[CDATA\[(.*?)\]\]>", r"\1", s or "", flags=re.S)
    s = html.unescape(re.sub(r"<[^>]+>", " ", html.unescape(s)))
    return re.sub(r"\s+", " ", s).replace("|", "/").strip()

def tag(block, *names):
    for n in names:
        m = re.search(rf"<{n}(?:\s[^>]*)?>(.*?)</{n}>", block, flags=re.S)
        if m and m.group(1).strip():
            return m.group(1)
    return ""

def when(s):
    s = clean(s)
    try:
        d = email.utils.parsedate_to_datetime(s)
    except Exception:
        try:
            d = datetime.datetime.fromisoformat(s.replace("Z", "+00:00"))
        except Exception:
            return None
    return d if d.tzinfo else d.replace(tzinfo=datetime.timezone.utc)

CACHE = {}
def fetch(url):
    if url not in CACHE:
        try:
            r = subprocess.run(["curl", "-sSL", "-m", "30", "-A", "Mozilla/5.0 (compatible; DailyBrief/1.0)",
                                "-w", "\n%{http_code}", url], capture_output=True, timeout=45)
            body, _, code = r.stdout.decode("utf8", "ignore").rpartition("\n")
            if code != "200":
                CACHE[url] = (None, f"HTTP {code or 'no response'} {r.stderr.decode('utf8', 'ignore').strip()[:120]}")
            else:
                items = re.findall(r"<item[\s>].*?</item>|<entry[\s>].*?</entry>", body, flags=re.S)
                CACHE[url] = (items, "") if items else (None, "fetched, but no feed items found (not RSS/Atom?)")
        except Exception as e:  # noqa: BLE001
            CACHE[url] = (None, f"{type(e).__name__}: {e}")
    return CACHE[url]

def link_of(block):
    l = clean(tag(block, "link"))
    if l.startswith("http"):
        return l
    m = re.search(r'<link[^>]*href="([^"]+)"', block)
    return m.group(1) if m else clean(tag(block, "guid", "id"))

src = {}
with open(os.path.join(ROOT, "rosters", "people-sources.csv"), encoding="utf8") as f:
    for r in csv.DictReader(f):
        src.setdefault(r["person"].strip().lower(), []).append(r)

with open(os.path.join(ROOT, "rosters", "people.csv"), encoding="utf8") as f:
    people = [r["person"].strip() for r in csv.DictReader(f) if r["person"].strip()]

counts = {"items": 0, "quiet": 0, "failed": 0, "nofeed": 0}
for p in people:
    print(f"\n## {p}")
    rows = src.get(p.lower())
    if not rows:
        print("NO_FEED"); counts["nofeed"] += 1; continue
    got = False
    for r in rows:
        items, err = fetch(r["url"].strip())
        if items is None:
            print(f"FEED_FAILED | {r['source']} | {r['url']} | {err}"); counts["failed"] += 1; continue
        newest, hits = None, []
        for it in items:
            who = clean(tag(it, "dc:creator", "author", "itunes:author"))
            title = clean(tag(it, "title"))
            summ = clean(tag(it, "description", "summary", "itunes:summary", "content:encoded", "content"))
            if r["match"].strip() and not re.search(r["match"].strip(), f"{title} {who} {summ}", flags=re.I):
                continue
            d = when(tag(it, "pubDate", "published", "updated", "dc:date"))
            if not d:
                continue
            newest = d if newest is None or d > newest else newest
            if d >= START:
                hits.append((d, title, link_of(it), summ[:400]))
        for d, title, link, summ in sorted(hits, reverse=True)[:8]:
            print(f"FEED_ITEM | {d.date()} | {r['source']} ({r['kind']}) | {title} | {link} | {summ}")
            counts["items"] += 1; got = True
        if not hits:
            print(f"FEED_QUIET | {r['source']} | newest item {newest.date() if newest else 'none matching'}")
    if not got:
        counts["quiet"] += 1
print(f"\nSUMMARY: {len(people)} people; {len(people) - counts['nofeed'] - counts['quiet']} with feed items, "
      f"{counts['quiet']} with feeds but nothing in window, {counts['nofeed']} with no feed, "
      f"{counts['failed']} feed fetches failed; window = last {DAYS} days")
