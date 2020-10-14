#!/bin/bash
set -euo pipefail

echo "Generating SSH Keys..."

if [ ! -d "$HOME"/.ssh ]; then
  echo "Creating .ssh files..."
  mkdir "$HOME/.ssh" && echo "$GITHUB_RSA_PRIV" > "$HOME/.ssh/id_rsa" && echo "$GITHUB_RSA_PUB" > "$HOME/.ssh/id_rsa.pub"
fi

echo "Pushing to GitHub..."

git remote add github ssh://git@github.com/pingidentity/pingidentity-solutions-c360.git >/dev/null \
  >/dev/null || echo 'Remote already exists, skipping creation...'
git push github "${CI_COMMIT_TAG}"

exit 0