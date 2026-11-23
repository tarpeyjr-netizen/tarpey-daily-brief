#!/usr/bin/env node
// Data + HTML builder for today.html (jobs/today.md).
//
// Usage:  node jobs/tools/today.mjs <out.html> [--date YYYY-MM-DD]
//
// Fetches weather (Open-Meteo), index closes (Yahoo Finance daily chart) and team schedules
// (ESPN site API) and writes the complete page with two placeholders the routine fills:
//   <!-- HEADLINES -->      the Headlines section (jobs/today.md step 3)
//   <!-- MANUAL_TEAMS -->   rows for teams the feeds could not cover (step 4), if any
// Prints a JSON summary on stdout: { gaps:[...], manual:[{team,source,reason}], skipped:[...] }.
// Never invents a figure. A failed fetch becomes a gap, never an estimate.

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const TZ = "America/New_York";
const HERE = path.dirname(fileURLToPath(import.meta.url));
const ROSTER = path.join(HERE, "..", "rosters", "today-teams.csv");
const out = process.argv[2];
if (!out) { console.error("usage: node today.mjs <out.html> [--date YYYY-MM-DD]"); process.exit(2); }
const dArg = process.argv.indexOf("--date");

// ---------- dates (all ET) ----------
const etDate = (d) => new Intl.DateTimeFormat("en-CA", { timeZone: TZ, year: "numeric", month: "2-digit", day: "2-digit" }).format(d);
const TODAY = dArg > 0 ? process.argv[dArg + 1] : etDate(new Date());
const addDays = (iso, n) => { const d = new Date(iso + "T12:00:00Z"); d.setUTCDate(d.getUTCDate() + n); return d.toISOString().slice(0, 10); };
const YESTERDAY = addDays(TODAY, -1);
const longDate = (iso) => new Date(iso + "T12:00:00Z").toLocaleDateString("en-US", { timeZone: "UTC", weekday: "long", month: "long", day: "numeric", year: "numeric" });
const etTime = (d) => d.toLocaleTimeString("en-US", { timeZone: TZ, hour: "numeric", minute: "2-digit" }).replace(":00", "").replace(" AM", " a.m.").replace(" PM", " p.m.");

const gaps = [], manual = [], skipped = [];
const esc = (s) => String(s ?? "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

async function getJSON(url, tries = 3) {
  let last = "";
  for (let i = 0; i < tries; i++) {
    if (i) await new Promise((r) => setTimeout(r, 4000 * i));
    try {
      const r = await fetch(url, { headers: { "User-Agent": "Mozilla/5.0", Accept: "application/json" }, signal: AbortSignal.timeout(25000) });
      if (!r.ok) { last = `HTTP ${r.status}`; continue; }
      return await r.json();
    } catch (e) { last = `${e.name}: ${e.message}`; }
  }
  throw new Error(`${last} (${url.split("?")[0]})`);
}

async function getText(url, tries = 2) {
  let last = "";
  for (let i = 0; i < tries; i++) {
    if (i) await new Promise((r) => setTimeout(r, 5000));
    try {
      const r = await fetch(url, { headers: { "User-Agent": "Mozilla/5.0", Accept: "text/html" }, signal: AbortSignal.timeout(30000) });
      if (!r.ok) { last = `HTTP ${r.status}`; continue; }
      return await r.text();
    } catch (e) { last = `${e.name}: ${e.message}`; }
  }
  throw new Error(`${last} (${url})`);
}
const unent = (s) => s.replace(/<[^>]+>/g, "").replace(/&#0?39;|&rsquo;/g, "'").replace(/&quot;/g, '"').replace(/&amp;/g, "&").replace(/\s+/g, " ").trim();

// ---------- entertainment ----------
// Billboard chart pages: the No. 1 row is the first .o-chart-results-list-row-container; its first three
// small labels are last week, peak, weeks on chart. Box Office Mojo: the newest weekend with a No. 1 film.
async function billboardTop(slug, label) {
  try {
    const h = await getText(`https://www.billboard.com/charts/${slug}/`);
    const row = h.split("o-chart-results-list-row-container")[1] ?? "";
    const title = unent((row.match(/<h3[^>]*id="title-of-a-story"[^>]*>([\s\S]*?)<\/h3>/) || [])[1] || "");
    const artist = unent((row.match(/<h3[^>]*id="title-of-a-story"[^>]*>[\s\S]*?<\/h3>\s*<span[^>]*>([\s\S]*?)<\/span>/) || [])[1] || "");
    const [lw, , wks] = [...row.matchAll(/<span class="c-label[^"]*u-font-size-12[^"]*"[^>]*>\s*([^<]*?)\s*<\/span>/g)].map((m) => m[1]).filter(Boolean);
    const week = (h.match(/Week of ([A-Z][a-z]+ \d{1,2}, \d{4})/) || [])[1];
    if (!title || !artist || !week) throw new Error("chart layout not recognised");
    return { label, slug, title, artist, week, lw, wks };
  } catch (e) { gaps.push(`Billboard ${label}: ${e.message}`); return { label, slug, error: true }; }
}

async function boxOffice() {
  try {
    const cal = await getText("https://www.boxofficemojo.com/weekend/");
    const row = (cal.match(/<tr[\s\S]*?<\/tr>/g) || []).find((r) => /\/release\/rl/.test(r));
    const href = row && (row.match(/href="(\/weekend\/\d{4}W\d+\/)/) || [])[1];
    if (!href) throw new Error("no completed weekend listed");
    const wk = await getText("https://www.boxofficemojo.com" + href);
    const rows = wk.match(/<tr[\s\S]*?<\/tr>/g) || [];
    const cells = (r) => (r.match(/<t[dh][^>]*>[\s\S]*?<\/t[dh]>/g) || []).map(unent);
    const head = cells(rows[0]), top = cells(rows[1]), col = (n) => top[head.indexOf(n)];
    const dates = unent((row.match(/<td[^>]*>([\s\S]*?)<\/td>/) || [])[1] || "").replace("-", "–");
    if (col("Rank") !== "1") throw new Error("weekend table layout not recognised");
    const g = +String(col("Gross")).replace(/[$,]/g, "");
    return { title: col("Release"), gross: g ? `$${(g / 1e6).toFixed(1)}M` : col("Gross"), weeks: col("Weeks"), dist: col("Distributor"), est: col("Estimated") === "true", dates, url: "https://www.boxofficemojo.com" + href };
  } catch (e) { gaps.push(`Box office: ${e.message}`); return { error: true }; }
}

const shortWeek = (w) => w.replace(/^([A-Z][a-z]{2})[a-z]*/, "$1.").replace("May.", "May").replace(/, \d{4}$/, "");
function chartTile(c, kind) {
  if (c.error) return `<div class="tile"><div class="t-label">No. 1 ${kind}</div><div class="t-line muted">Unavailable</div></div>`;
  const move = c.lw === "1" ? "Holds at No. 1" : c.lw && c.lw !== "-" ? `Up from No. ${esc(c.lw)}` : "New at No. 1";
  return `<div class="tile"><div class="t-label">No. 1 ${kind}</div>
<div class="t-title">${esc(c.title)}</div>
<div class="t-line">${esc(c.artist)}</div>
<div class="t-line muted">${move} &middot; ${esc(c.wks)} wks on chart</div></div>`;
}
function movieTile(m) {
  if (m.error) return `<div class="tile"><div class="t-label">No. 1 movie</div><div class="t-line muted">Unavailable</div></div>`;
  return `<div class="tile"><div class="t-label">No. 1 movie</div>
<div class="t-title">${esc(m.title)}</div>
<div class="t-line">${esc(m.gross)} weekend${m.est ? " (est.)" : ""}</div>
<div class="t-line muted">${esc(m.dates)} &middot; ${m.weeks === "1" ? "opening weekend" : `week ${esc(m.weeks)}`}</div></div>`;
}

// ---------- weather ----------
const WMO = { 0: "Clear", 1: "Mostly clear", 2: "Partly cloudy", 3: "Cloudy", 45: "Fog", 48: "Freezing fog", 51: "Light drizzle", 53: "Drizzle", 55: "Heavy drizzle", 56: "Freezing drizzle", 57: "Freezing drizzle", 61: "Light rain", 63: "Rain", 65: "Heavy rain", 66: "Freezing rain", 67: "Freezing rain", 71: "Light snow", 73: "Snow", 75: "Heavy snow", 77: "Snow grains", 80: "Rain showers", 81: "Rain showers", 82: "Heavy showers", 85: "Snow showers", 86: "Heavy snow showers", 95: "Thunderstorms", 96: "Thunderstorms, hail", 99: "Thunderstorms, hail" };
const CITIES = [["Durham, NC", 35.994, -78.8986], ["Denver, CO", 39.7392, -104.9903]];

async function weatherTile([name, lat, lon]) {
  try {
    const j = await getJSON(`https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&temperature_unit=fahrenheit&timezone=America%2FNew_York&forecast_days=2`);
    const d = j.daily, r = Math.round;
    return `<div class="tile"><div class="t-label">${esc(name)}</div>
<div class="t-big">${r(j.current.temperature_2m)}&deg;F</div>
<div class="t-line">${esc(WMO[j.current.weather_code] ?? "Unknown")}</div>
<div class="t-line">Today ${r(d.temperature_2m_max[0])}&deg; / ${r(d.temperature_2m_min[0])}&deg; &middot; ${d.precipitation_probability_max[0] ?? "&ndash;"}% precip</div>
<div class="t-line muted">Tomorrow ${r(d.temperature_2m_max[1])}&deg; / ${r(d.temperature_2m_min[1])}&deg;</div></div>`;
  } catch (e) {
    gaps.push(`Weather ${name}: ${e.message}`);
    return `<div class="tile"><div class="t-label">${esc(name)}</div><div class="t-line muted">Weather unavailable</div></div>`;
  }
}

// ---------- markets ----------
const INDEXES = [["Dow", "^DJI"], ["S&amp;P 500", "^GSPC"], ["Nasdaq", "^IXIC"]];
const fmt = (n, dp = 2) => n.toLocaleString("en-US", { minimumFractionDigits: dp, maximumFractionDigits: dp });

async function market([label, sym]) {
  try {
    const j = await getJSON(`https://query1.finance.yahoo.com/v8/finance/chart/${encodeURIComponent(sym)}?range=1y&interval=1d`);
    const res = j.chart.result[0], q = res.indicators.quote[0];
    // Completed sessions only: any bar dated today (ET) is in progress before 4 p.m. and is dropped.
    const nowET = new Intl.DateTimeFormat("en-US", { timeZone: TZ, hour: "numeric", hourCycle: "h23" }).format(new Date());
    const rows = res.timestamp.map((t, i) => ({ date: etDate(new Date(t * 1000)), close: q.close[i], high: q.high[i] }))
      .filter((x) => x.close != null && (x.date < TODAY || (x.date === TODAY && +nowET >= 17)));
    const last = rows.at(-1), prev = rows.at(-2);
    const chg = last.close - prev.close, pct = (chg / prev.close) * 100;
    // notes: streak, week move, drawdown from 52-week closing high
    let streak = 1; for (let i = rows.length - 1; i > 1 && Math.sign(rows[i].close - rows[i - 1].close) === Math.sign(rows[i - 1].close - rows[i - 2].close); i--) streak++;
    const wk = rows.at(-6), wkPct = wk ? ((last.close - wk.close) / wk.close) * 100 : null;
    const hi = Math.max(...rows.map((x) => x.close)), dd = ((last.close - hi) / hi) * 100;
    return { label, date: last.date, close: last.close, chg, pct, streak, dir: Math.sign(chg), wkPct, dd };
  } catch (e) { gaps.push(`Markets ${label}: ${e.message}`); return { label, error: true }; }
}

function marketTile(m) {
  if (m.error) return `<div class="tile"><div class="t-label">${m.label}</div><div class="t-line muted">Unavailable</div></div>`;
  const up = m.chg >= 0, sign = up ? "+" : "&minus;", cls = up ? "up" : "down", arrow = up ? "&#9650;" : "&#9660;";
  return `<div class="tile"><div class="t-label">${m.label}</div>
<div class="t-big">${fmt(m.close)}</div>
<div class="t-line ${cls}">${arrow} ${sign}${fmt(Math.abs(m.chg))} (${sign}${fmt(Math.abs(m.pct))}%)</div></div>`;
}

function marketNote(ms) {
  const ok = ms.filter((m) => !m.error); if (!ok.length) return "";
  const notes = [];
  const corr = ok.filter((m) => m.dd <= -10), pull = ok.filter((m) => m.dd <= -5 && m.dd > -10);
  if (corr.length) notes.push(`${corr.map((m) => m.label).join(", ")} in correction territory (${corr.map((m) => fmt(m.dd, 1) + "%").join(", ")} from the 52-week closing high)`);
  else if (pull.length) notes.push(`${pull.map((m) => m.label).join(", ")} ${pull.length > 1 ? "are" : "is"} ${pull.map((m) => fmt(Math.abs(m.dd), 1) + "%").join(", ")} below the 52-week closing high`);
  const s = ok.find((m) => m.streak >= 3); if (s) notes.push(`${s.label} ${s.dir > 0 ? "up" : "down"} ${s.streak} sessions in a row`);
  const w = ok.find((m) => m.wkPct != null && Math.abs(m.wkPct) >= 2); if (w) notes.push(`${w.label} ${w.wkPct > 0 ? "+" : "&minus;"}${fmt(Math.abs(w.wkPct), 1)}% over the last 5 sessions`);
  return notes.length ? `<p class="note">${notes.slice(0, 2).join("; ")}.</p>` : "";
}

// ---------- teams ----------
const MON = { Jan: 1, Feb: 2, Mar: 3, Apr: 4, May: 5, Jun: 6, Jul: 7, Aug: 8, Sep: 9, Oct: 10, Nov: 11, Dec: 12 };
function inWindow(season, iso) {
  const [a, b] = season.split("-").map((m) => MON[m.trim()]), m = +iso.slice(5, 7);
  return a <= b ? m >= a && m <= b : m >= a || m <= b;
}
const readRoster = () => {
  const [head, ...lines] = fs.readFileSync(ROSTER, "utf8").trim().split(/\r?\n/);
  const keys = head.split(",");
  return lines.filter(Boolean).map((l) => Object.fromEntries(l.split(",").map((v, i) => [keys[i], v.trim()])));
};
const scoreOf = (c) => (c.score && typeof c.score === "object" ? c.score.displayValue ?? c.score.value : c.score);

async function teamEvents(t) {
  const base = `https://site.api.espn.com/apis/site/v2/sports/${t.espn_path}/teams/${t.espn_id}/schedule`;
  const urls = [base];
  if (t.espn_path.startsWith("soccer/")) urls.push(base + "?fixture=true");        // soccer splits results and fixtures
  if (t.espn_path.includes("football") || t.espn_path.endsWith("nba") || t.espn_path.endsWith("nhl")) urls.push(base + "?seasontype=3"); // postseason
  const seen = new Map();
  for (const u of urls) {
    try { for (const e of (await getJSON(u, u === base ? 3 : 1)).events ?? []) seen.set(e.id, e); }
    catch (e) { if (u === base) throw e; }
  }
  return [...seen.values()].map((e) => {
    const c = e.competitions[0], me = c.competitors.find((x) => x.id === t.espn_id || x.team?.id === t.espn_id), op = c.competitors.find((x) => x !== me);
    const st = c.status?.type ?? {}, start = new Date(e.date);
    return { start, date: etDate(start), timeTBD: c.timeValid === false || st.name === "STATUS_TBD", home: me?.homeAway === "home", neutral: !!c.neutralSite,
      opp: op?.team?.shortDisplayName || op?.team?.displayName || "TBD", state: st.state, detail: st.shortDetail || st.description || "",
      final: st.completed === true, postponed: /POSTPONED|CANCELED|SUSPENDED/.test(st.name || ""),
      my: me && scoreOf(me), their: op && scoreOf(op), winner: me?.winner, oppWinner: op?.winner };
  }).sort((a, b) => a.start - b.start);
}

const vsAt = (g) => (g.neutral ? "vs." : g.home ? "vs." : "at");
const loc = (g) => (g.neutral ? "Neutral" : g.home ? "Home" : "Away");
function resultCell(g) {
  if (g.postponed) return `<span class="muted">${esc(g.detail || "Postponed")}</span>`;
  if (!g.final) return null;
  const r = g.winner ? "W" : g.oppWinner ? "L" : "T", cls = r === "W" ? "win" : r === "L" ? "loss" : "tie";
  const ot = /OT|SO|\/\d/.test(g.detail) ? ` <span class="muted">(${esc(g.detail.replace(/^Final\/?/, "") || "OT")})</span>` : "";
  return `<span class="nw"><span class="res ${cls}">${r}</span> ${esc(g.my)}&ndash;${esc(g.their)}</span>${ot}`;
}
const timeOf = (g) => (g.timeTBD ? "TBD" : etTime(g.start) + " ET");

async function main() {
  const [wx, mk] = await Promise.all([Promise.all(CITIES.map(weatherTile)), Promise.all(INDEXES.map(market))]);
  const mDate = mk.find((m) => !m.error)?.date;
  const [movie, song, album, ...genre] = await Promise.all([boxOffice(),
    billboardTop("hot-100", "Hot 100"), billboardTop("billboard-200", "Billboard 200"),
    billboardTop("americana-folk-albums", "Americana/Folk Albums"), billboardTop("bluegrass-albums", "Bluegrass Albums"), billboardTop("hot-rock-songs", "Hot Rock Songs")]);
  const chartWeek = [song, album, ...genre].find((c) => !c.error)?.week;
  const genreRows = genre.map((c) => c.error
    ? `<tr><td>${esc(c.label)}</td><td class="muted" colspan="2">Unavailable</td></tr>`
    : `<tr><td>${esc(c.label)}</td><td><strong>${esc(c.title)}</strong></td><td>${esc(c.artist)}</td></tr>`);

  const yRows = [], tRows = [], offSeason = [], noResult = [];
  for (const t of readRoster()) {
    if (!inWindow(t.season, TODAY)) { offSeason.push(t.team); continue; }
    if (!t.espn_path) { manual.push({ team: t.team, source: t.fallback_source, reason: "no feed for this team" }); continue; }
    let ev;
    try { ev = await teamEvents(t); }
    catch (e) { manual.push({ team: t.team, source: t.fallback_source, reason: e.message }); gaps.push(`${t.team}: ESPN feed failed (${e.message})`); continue; }
    // In the month window but nothing within 3 weeks either side = season over (eliminated, done early).
    const near = ev.filter((g) => Math.abs(g.start - new Date(TODAY + "T12:00:00Z")) <= 21 * 864e5);
    if (!near.length) { offSeason.push(t.team); continue; }
    const name = `<strong>${esc(t.team)}</strong>`;
    for (const g of ev.filter((g) => g.date === YESTERDAY)) {
      const r = resultCell(g);
      if (r) yRows.push(`<tr><td>${name}</td><td>${r}</td><td>${vsAt(g)} ${esc(g.opp)}</td><td>${loc(g)}</td></tr>`);
      else { noResult.push(t.team); yRows.push(`<tr><td>${name}</td><td class="muted">No result found</td><td>${vsAt(g)} ${esc(g.opp)}</td><td>${loc(g)}</td></tr>`); }
    }
    for (const g of ev.filter((g) => g.date === TODAY))
      tRows.push(`<tr><td>${name}</td><td>${vsAt(g)} ${esc(g.opp)}</td><td>${resultCell(g) ?? (g.state === "in" ? `<span class="muted">Live &middot; ${esc(g.detail)}</span>` : timeOf(g))}</td><td>${loc(g)}</td></tr>`);
  }
  if (noResult.length) gaps.push(`No final score in the ESPN feed for: ${noResult.join(", ")}`);
  for (const m of manual) gaps.push(`${m.team}: not in the ESPN feed &mdash; checked ${m.source} by hand`);
  skipped.push(...offSeason);

  const table = (head, rows, empty) => rows.length
    ? `<div class="tbl-wrap"><table><thead><tr>${head.map((h) => `<th>${h}</th>`).join("")}</tr></thead><tbody>\n${rows.join("\n")}\n</tbody></table></div>`
    : `<p class="muted">${empty}</p>`;

  const BUILD = process.env.BUILD_ID || new Date().toISOString().replace(/\.\d+Z$/, "Z").replace(/:/g, "");
  const html = `<!-- build: ${BUILD} -->
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="noindex, nofollow">
<title>Today &mdash; The Daily Brief</title>
<style>
  :root { --navy:#1f3a5f; --ink:#1c2330; --muted:#6a7280; --line:#e3e6ec; --bg:#f4f6fa; --accent:#1f5fae; --up:#1b7a43; --down:#b3261e; }
  * { box-sizing:border-box; margin:0; padding:0; }
  body { font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Arial,Helvetica,sans-serif; background:var(--bg); color:var(--ink); -webkit-font-smoothing:antialiased; }
  .wrap { max-width:640px; margin:0 auto; }
  header { background:var(--navy); color:#fff; padding:26px 16px 22px; }
  .back { display:inline-block; font-size:13px; color:#b9c6da; text-decoration:none; margin-bottom:12px; }
  header h1 { font-size:25px; font-weight:700; }
  header .sub { margin-top:6px; font-size:13.5px; color:#b9c6da; }
  main { padding:20px 16px 48px; }
  article.edition { margin-bottom:24px; }
  .ed-head { font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:.6px; color:var(--muted); margin-bottom:12px; }
  section { background:#fff; border:1px solid var(--line); border-radius:12px; padding:18px 16px; margin-bottom:16px; }
  h2 { font-size:17px; color:var(--navy); margin-bottom:10px; }
  p { font-size:14px; line-height:1.55; margin-bottom:8px; }
  .muted { color:var(--muted); font-size:13px; }
  .tiles { display:grid; grid-template-columns:repeat(auto-fit,minmax(150px,1fr)); gap:10px; }
  .tiles.mk { grid-template-columns:repeat(auto-fit,minmax(130px,1fr)); }
  .tile { border:1px solid var(--line); border-top:3px solid var(--accent); border-radius:8px; padding:10px 12px; }
  .t-label { font-size:11.5px; font-weight:700; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); }
  .t-big { font-size:22px; font-weight:700; margin:2px 0; font-variant-numeric:tabular-nums; }
  .t-line { font-size:13px; line-height:1.45; font-variant-numeric:tabular-nums; }
  .t-title { font-size:16px; font-weight:700; line-height:1.3; margin:3px 0 2px; overflow-wrap:anywhere; }
  .up { color:var(--up); } .down { color:var(--down); }
  .note { font-size:13px; margin:10px 0 0; padding-left:10px; border-left:3px solid var(--accent); }
  table { width:100%; border-collapse:collapse; font-size:13.5px; }
  th { text-align:left; font-size:11px; text-transform:uppercase; letter-spacing:.5px; color:var(--muted); border-bottom:1px solid var(--line); padding:6px 6px 6px 0; }
  td { padding:7px 6px 7px 0; border-bottom:1px solid var(--line); line-height:1.4; vertical-align:top; font-variant-numeric:tabular-nums; }
  .tbl-wrap { overflow-x:auto; }
  .res { display:inline-block; min-width:18px; text-align:center; font-size:11px; font-weight:700; padding:1px 4px; border-radius:4px; color:#fff; }
  td .res { margin-right:3px; } .nw { white-space:nowrap; }
  .win { background:var(--up); } .loss { background:var(--down); } .tie { background:var(--muted); }
  ul.heads { list-style:none; } ul.heads li { padding:8px 0; border-bottom:1px solid var(--line); font-size:14px; line-height:1.5; }
  ul.heads li:last-child { border-bottom:none; }
  a { color:var(--accent); }
  .sources { font-size:12px; color:var(--muted); line-height:1.6; }
  footer { text-align:center; font-size:12px; color:var(--muted); padding:24px 16px; }
</style>
</head>
<body>
<header><div class="wrap">
<a class="back" href="/">&larr; Back to dashboard</a>
<h1>Today</h1>
<div class="sub">${longDate(TODAY)} &middot; weather, markets, scores, headlines</div>
</div></header>
<main class="wrap">
<article class="edition" data-date="${TODAY}">
<div class="ed-head">${longDate(TODAY)}</div>

<section>
<h2>Weather</h2>
<div class="tiles">
${wx.join("\n")}
</div>
</section>

<section>
<h2>Markets</h2>
<p class="muted">Close for ${mDate ? longDate(mDate) : "the last trading day"}</p>
<div class="tiles mk">
${mk.map(marketTile).join("\n")}
</div>
${marketNote(mk)}
</section>

<section>
<h2>Yesterday&rsquo;s scores</h2>
<p class="muted">${longDate(YESTERDAY)}</p>
${table(["Team", "Result", "Opponent", "Site"], yRows, "None of your in-season teams played yesterday.")}
</section>

<section>
<h2>Today&rsquo;s games</h2>
${table(["Team", "Opponent", "Time / Final", "Site"], tRows, "None of your in-season teams play today.")}
<!-- MANUAL_TEAMS -->
${offSeason.length ? `<p class="muted" style="margin-top:10px">Off-season: ${offSeason.map(esc).join(", ")}.</p>` : ""}
</section>

<section>
<h2>Entertainment</h2>
<p class="muted">Box office: US weekend${movie.error ? "" : `, ${esc(movie.dates)}`}. Billboard charts: week of ${chartWeek ? esc(shortWeek(chartWeek)) : "the latest chart"}.</p>
<div class="tiles">
${movieTile(movie)}
${chartTile(song, "song")}
${chartTile(album, "album")}
</div>
<div class="tbl-wrap" style="margin-top:12px"><table><thead><tr><th>Billboard chart</th><th>No. 1</th><th>Artist</th></tr></thead><tbody>
${genreRows.join("\n")}
</tbody></table></div>
</section>

<!-- HEADLINES -->

<section>
<h2>Sources</h2>
<p class="sources">Weather: Open-Meteo. Markets: Yahoo Finance daily closes. Scores and schedules: ESPN. Box office: Box Office Mojo. Charts: Billboard. Headlines: Associated Press, via PBS NewsHour (linked on each item).</p>
<p class="sources">Gaps: ${gaps.length ? gaps.map(esc).join("; ").replace(/&amp;mdash;/g, "&mdash;") : "none"}.</p>
</section>
</article>
</main>
<footer>The Daily Brief &middot; Today &middot; rebuilt every morning</footer>
<script>document.querySelectorAll('main a[href^="http"]').forEach(a=>{a.target='_blank';a.rel='noopener noreferrer';});</script>
</body>
</html>
`;
  fs.writeFileSync(out, html, "utf8");
  console.log(JSON.stringify({ date: TODAY, marketDate: mDate, gaps, manual, skipped }, null, 1));
}

main().catch((e) => { console.error("FATAL", e.stack || e); process.exit(1); });
