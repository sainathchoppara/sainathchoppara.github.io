#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: run this script inside a git repository."
  exit 1
fi

branch="$(git branch --show-current)"
if [[ -z "${branch}" ]]; then
  echo "Error: unable to detect current branch."
  exit 1
fi

if [[ "${branch}" != "main" ]]; then
  echo "Error: current branch is '${branch}'. Switch to 'main' before publishing."
  exit 1
fi

if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to publish."
  exit 0
fi

message="${1:-Update site content}"

git add -A

if git diff --cached --quiet; then
  echo "No staged changes to commit after add."
  exit 0
fi

git commit -m "${message}"
git push origin main

echo "Published commit to origin/main."
