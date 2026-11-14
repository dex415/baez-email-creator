#!/usr/bin/env bash
# One-shot: git → GitHub → Pages. Safe to re-run for every update.
#   bash deploy.sh                 first run creates the repo and turns Pages on
#   bash deploy.sh "what changed"  later runs commit + push
set -euo pipefail

REPO_NAME="baez-email-creator"
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -f index.html ] || { echo "index.html is missing from $(pwd)"; exit 1; }
touch .nojekyll

if [ ! -d .git ]; then
  git init -b main -q
  git add -A
  git commit -qm "BAEZ Email Creator"
else
  git add -A
  git commit -qm "${1:-update BAEZ email creator}" 2>/dev/null || echo "  (no changes to commit)"
fi

if ! command -v gh >/dev/null 2>&1; then
  cat <<MANUAL

GitHub CLI isn't installed. Fastest fix:
    brew install gh && gh auth login
...then re-run this script.

Or do it by hand — create an empty PUBLIC repo named $REPO_NAME, then:
    cd "$(pwd)"
    git remote add origin https://github.com/<your-username>/$REPO_NAME.git
    git push -u origin main
Then: repo Settings -> Pages -> Deploy from a branch -> main -> / (root)
MANUAL
  exit 0
fi

gh auth status >/dev/null 2>&1 || gh auth login

if git remote get-url origin >/dev/null 2>&1; then
  git push -q origin main
else
  gh repo create "$REPO_NAME" --public --source=. --push
fi

OWNER="$(gh api user -q .login)"
gh api -X POST "repos/$OWNER/$REPO_NAME/pages" \
     -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
     && echo "Pages enabled." \
     || echo "Pages already configured (or set it in Settings -> Pages)."

echo ""
echo "  https://$OWNER.github.io/$REPO_NAME/"
echo "  First build takes about a minute."
