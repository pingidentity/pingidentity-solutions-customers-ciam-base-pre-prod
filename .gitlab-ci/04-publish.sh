#!/bin/bash
set -euo pipefail

echo "Pushing to GitHub..."

git remote add github ssh://git@github.com/pingidentity/pingidentity-solutions-c360.git >/dev/null || echo 'Remote already exists, skipping creation.'
git branch -M main
git push -u github main

exit 0