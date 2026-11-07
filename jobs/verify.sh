#!/bin/bash
# Usage: bash jobs/verify.sh <workdir> <page> [page...]
# Polls the live site (short sleeps, up to ~2 min) until each page shows its build stamp.
WORKDIR="$1"; shift
for PAGE in "$@"; do
  STAMP=$(grep -m1 -o '<!-- build: [^ ]*' "$WORKDIR/$PAGE.html" | sed 's/.*build: //')
  OK=0
  for i in 1 2 3 4 5 6; do
    if curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html" | grep -q "build: $STAMP"; then
      OK=1
      break
    fi
    sleep 20
  done
  if [ "$OK" = 1 ]; then
    echo "VERIFY_OK: $PAGE"
  else
    LIVE=$(curl -sL --max-time 20 "https://tarpey-daily-brief.pages.dev/$PAGE.html" | grep -o '<!-- build: [^>]*-->' | head -1)
    echo "FAIL_VERIFY: $PAGE - live stamp: $LIVE"
  fi
done
