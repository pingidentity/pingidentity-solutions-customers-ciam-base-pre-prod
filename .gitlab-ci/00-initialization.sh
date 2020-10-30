#!/bin/bash
set -xeo pipefail

pwd
env
echo "$USER"
type jq
type docker
docker info
type docker-compose
docker-compose version
type envsubst
envsubst --version
type git
git --version
type sed
sed --version
cat /proc/meminfo
exit 0