#!/bin/bash
set -euo pipefail

git clone "https://${GITLAB_USER}:${GITLAB_TOKEN}@gitlab.corp.pingidentity.com/solutions/customer360.git"
cd customer360 || exit 97
git config user.email "pd-solutions@pingidentity.com"
git config user.name "pd-solutions"

git remote add gh_location "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/pingidentity/pingidentity-solutions-c360.git"

if test -n "$CI_COMMIT_TAG"
then
    git push gh_location "$CI_COMMIT_TAG"
fi

git push gh_location master

exit 0