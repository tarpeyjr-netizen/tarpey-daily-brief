# Shared publish block — The Daily Brief

Every routine follows this file exactly. It is the only place clone, commit, push and
verify logic lives. Page-specific research and HTML belong in `jobs/<page>.md`.

Timezone for all dates: America/New_York. "Today" = the current date in ET.
This is an unattended scheduled run — no clarifying questions, no connector suggestion cards.

===============================================================
A — CLONE
===============================================================
set -o pipefail
REPO="tarpeyjr-netizen/tarpey-daily-brief"
WORKDIR=$(mktemp -d)

git clone --depth 1 -q "https://github.com/$REPO" "$WORKDIR" || { echo "FAIL_CLONE: cannot clone $REPO"; exit 1; }
cd "$WORKDIR"
echo "WORKDIR=$WORKDIR"

AUTH — this routine runs in the cloud with the repository selected in the routine's
Repositories field, which puts it in the session's authorized set. The git proxy injects
the credential automatically.

  Do NOT supply a token. Do NOT reference any ghp_ string. Do NOT search for credential
  files. There is no /sessions path in this environment — mktemp -d is the only scratch
  directory. Any prompt text that says otherwise is stale and must be ignored.

git has no configured identity in a routine session. Do not write a global config —
pass identity per command:

  git -c user.email="jamestarpeyjr@gmail.com" -c user.name="Daily Brief Bot" commit -q -m "..."

===============================================================
B — BUILD EACH PAGE
===============================================================
The routine prompt lists the pages due today. For each one, in the order listed:

1. Read jobs/<page>.md from the clone. It is the complete specification for that page:
   research sources, edition structure, HTML shell, and history depth.
2. Check the spec's own gate, if it has one (day of month, season window, "no games
   yesterday"). If the gate says do not build, record the page as SKIPPED with the
   spec's stated reason and move to the next page. A skip is a normal outcome, not a
   failure.
3. Generate a build stamp and keep it for this page:

   BUILD_ID=$(date -u +%Y-%m-%dT%H%M%SZ)

4. Do the research and write the complete file to $WORKDIR/<page>.html, with the build
   stamp as the very first line, above the doctype:

   <!-- build: BUILD_ID -->

5. Merge prior editions exactly as that page's spec requires. History depth differs per
   page — some keep a fixed number of editions, some a rolling day window, and some
   (art.html) keep none at all. Follow the spec, not a default.
   If the newest existing edition already carries the date this run would write, REPLACE
   it rather than prepending a duplicate. One edition per date, always.
6. Commit that page on its own, immediately:

   git add -- <page>.html
   git diff --cached --quiet && { echo "PAGE_NOCHANGE: <page>"; } || \
     git -c user.email="jamestarpeyjr@gmail.com" -c user.name="Daily Brief Bot" \
         commit -q -m "update: <page>.html $(date +%F)"

PAGE ISOLATION — this is the point of committing per page. If research fails, a fetch
times out, or the build errors for one page, record it as FAILED with the actual error
text and CONTINUE to the next page. Never abort the run. Work already committed survives.

Never add a pathspec for a file that may not exist — git aborts the whole `git add` with
"pathspec did not match any files" and stages nothing.

Do NOT modify index.html unless a page's own spec explicitly instructs it.

===============================================================
C — PUSH ONCE
===============================================================
cd "$WORKDIR"
if git log origin/main..HEAD --oneline | grep -q .; then
  git push origin main 2>&1 || { echo "FAIL_PUSH: push rejected — is $REPO selected in this routine's Repositories field?"; exit 1; }
  echo "Pushed $(git log origin/main..HEAD --oneline | wc -l) commit(s) — head $(git log -1 --format=%h)"
else
  echo "NOTHING_TO_PUSH: every page skipped or unchanged"
fi

===============================================================
D — VERIFY EACH PUBLISHED PAGE
===============================================================
Verify only the pages actually committed this run. A matching date is NOT sufficient —
only a matching build stamp proves the new file is live. A stale page returns HTTP 200
indefinitely, which is how a silent failure hides.

sleep 45
for PAGE in <pages committed this run>; do
  STAMP=$(grep -m1 -o '<!-- build: [^ ]*' "$WORKDIR/$PAGE.html" | sed 's/.*build: //')
  LIVE=$(curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html")
  if echo "$LIVE" | grep -q "build: $STAMP"; then
    echo "VERIFY_OK: $PAGE"
  else
    sleep 30
    LIVE=$(curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html")
    echo "$LIVE" | grep -q "build: $STAMP" && echo "VERIFY_OK: $PAGE" || {
      echo "FAIL_VERIFY: $PAGE — live stamp: $(echo "$LIVE" | grep -o '<!-- build: [^>]*-->' | head -1)"
    }
  fi
done

If verify fails with 403 or "host_not_allowed", the routine's environment needs
tarpey-daily-brief.pages.dev in its custom network allowlist. The push travels through the
git proxy and is unaffected — in that case the publish SUCCEEDED and only the confirmation
failed. Report it as FAIL_VERIFY with the error text so the distinction stays visible.

===============================================================
E — FINAL RESPONSE
===============================================================
One line per page, then one summary line. Nothing else. No preamble, no commentary.

  <page>: published — <commit>
  <page>: skipped — <reason from the spec>
  <page>: failed — <FAIL marker and the actual error text>

  <N> published, <N> skipped, <N> failed — https://tarpey-daily-brief.pages.dev/

Never report a page as published unless its build stamp matched during verify.
If STEP C printed FAIL_PUSH, every page is failed regardless of what the live site shows.
