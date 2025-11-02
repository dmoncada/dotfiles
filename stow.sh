#!/usr/bin/env bash

set -euo pipefail

NAME="$(basename "$0")"

stashed=""
if [ -n "$(git status --porcelain)" ] ; then
  echo "${NAME}: storing changes ..."
  git stash push --quiet
  stashed=1
fi

if ! stow . --target="$HOME" --simulate > /dev/null 2>&1 ; then
  echo "${NAME}: resolving coflicts ..."
  stow --adopt . --target="$HOME"
  git checkout .
fi

echo "${NAME}: stowing dotfiles ..."
stow --restow . --target="$HOME" --verbose=2

if [ -n "$stashed" ] ; then
  echo "${NAME}: restoring changes ..."
  git stash pop --quiet
fi

