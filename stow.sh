#!/usr/bin/env bash

set -euo pipefail

NAME="$(basename "$0")"

stashed=""
if [ -n "$(git status --porcelain)" ] ; then
  git stash push --quiet
  stashed=1
fi

if ! stow . --target="$HOME" --simulate ; then
  echo "${NAME}: adopting coflicts ..."
  stow --adopt . --target="$HOME"

  echo "${NAME}: dropping conflicts ..."
  git checkout .
fi

echo "${NAME}: stowing dotfiles ..."
stow --restow . --target="$HOME" --verbose=2

if [ -n "$stashed" ] ; then
  git stash pop --quiet
fi

