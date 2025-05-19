#!/usr/bin/env bash

set -euo pipefail

# Installs CLI tools using Homebrew.

NAME="$(basename $0)"

################################################################################
# Xcode Command Line Tools.
################################################################################

# If the Xcode CLI tools are not already installed...
if ! xcode-select --print-path &> /dev/null ; then # install them.
  echo "${NAME}: installing the Xcode command line tools ..."
  echo "${NAME}: re-run this script when finished."
  xcode-select --install
  exit 0
fi

################################################################################
# Homebrew.
################################################################################

# If brew is already installed...
if which -s brew ; then # update it.
  echo "${NAME}: updating and upgrading homebrew ..."
  brew update-if-needed
  brew upgrade

else # install and diagnose.
  echo "${NAME}: installing homebrew ..."
  bash -c $(curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install.sh")

  if [ "$?" -ne 0 ] ; then
    echo "${NAME}: the installation was aborted ..."
    exit 1
  fi

  echo "${NAME}: disabling analytics ..."
  brew analytics off

  echo "${NAME}: diagnosing homebrew ..."
  brew config
  brew doctor
fi

################################################################################
# Formulae.
################################################################################

echo "${NAME}: installing formulae ..."

formulae=(
bash
coreutils
diffutils
findutils
make
bat
fzf
git
jq
"python@3.13"
vim
wget
)

declare -A installed_formulae
while read -r name version ; do
  installed_formulae["$name"]="$version"
done <<< "$(brew list --version --formula)"

for formula in "${formulae[@]}" ; do
  if [[ ! -v installed_formulae[$formula] ]] ; then
    brew install "$formula" --display-times
  fi
done

BREW_PREFIX="$(brew --prefix)"
if [ "$SHELL" != "${BREW_PREFIX}/bin/bash" ] ; then
  echo "${NAME}: changing shell: $SHELL -> ${BREW_PREFIX}/bin/bash ..."
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/bash"
fi

################################################################################
# Casks.
################################################################################

echo "${NAME}: installing casks ..."

casks=(
1password
adobe-creative-cloud
chromium
font-cascadia-code
git-credential-manager
itsycal
miniconda
monitorcontrol
)

declare -A installed_casks
while read -r name version ; do
  installed_casks["$name"]="$version"
done <<< "$(brew list --version --cask)"

for cask in "${casks[@]}" ; do
  if [[ ! -v installed_casks[$cask] ]] ; then
    brew install "$cask" --cask --display-times
  fi
done

################################################################################
# Cleanup.
################################################################################

echo "${NAME}: cleaning up ..."

brew cleanup --prune=all
BREW_CACHE="$(brew --cache)"
[ -d $BREW_CACHE ] && rm -rf $BREW_CACHE

