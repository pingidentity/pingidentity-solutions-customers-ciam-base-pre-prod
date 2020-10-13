#!/bin/bash
set -euo pipefail

echo "Pushing to GitHub..."

git remote set-url --add origin ssh://git@github.com/pingidentity/pingidentity-solutions-c360.git
git branch -M main
git push -u origin main

exit 0