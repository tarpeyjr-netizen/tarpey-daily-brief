#!/bin/bash
# Usage: bash jobs/push.sh <workdir>   — pushes main once if there are new commits.
cd "$1" || exit 1
if [ -z "$(git log origin/main..HEAD --oneline)" ]; then
  echo "NOTHING_TO_PUSH: every page skipped or unchanged"
  exit 0
fi
N=$(git log origin/main..HEAD --oneline | wc -l)
if git push origin main 2>&1; then
  echo "Pushed $N commit(s) - head $(git log -1 --format=%h)"
else
  echo "FAIL_PUSH: push rejected - is the repo selected in this routine's Repositories field?"
  exit 1
fi
