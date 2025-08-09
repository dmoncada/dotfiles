#!/usr/bin/env bash

set -euo pipefail

shopt -s expand_aliases
alias is_macos='[ "$(uname)" = "Darwin" ]'
alias is_linux='[ "$(uname)" = "Linux" ]'

try_init_brew() {
  local prefix="$1"
  if [ -e "$prefix"/bin/brew ] ; then
    eval "$("$prefix"/bin/brew shellenv)"
  fi
}

# Installs CLI tools using Homebrew.

NAME="$(basename "$0")"

################################################################################
# Xcode Command Line Tools.
################################################################################

if is_macos ; then
  # If the Xcode CLI tools are not already installed...
  if ! xcode-select --print-path &> /dev/null ; then # install them.
    echo "${NAME}: installing the Xcode command line tools ..."
    echo "${NAME}: re-run this script when finished."
    xcode-select --install
    exit 0
  fi
fi

################################################################################
# Homebrew.
################################################################################

# If brew is already installed...
if which brew &> /dev/null ; then # update it.
  echo "${NAME}: updating and upgrading homebrew ..."
  brew update-if-needed
  brew outdated
  brew upgrade

else # install and diagnose.
  echo "${NAME}: installing homebrew ..."
  if ! bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" ; then
    echo "${NAME}: the installation was aborted ..."
    exit 1
  fi

  if is_macos ; then
    try_init_brew "/opt/homebrew"
  fi

  if is_linux ; then
    try_init_brew "/home/linuxbrew/.linuxbrew"
    sudo apt-get install build-essential --yes
    brew install gcc
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
curl
bat
fzf
git
glow
jq
just
"python@3.13"
shellcheck
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

if is_macos ; then
  echo "${NAME}: installing casks ..."

  casks=(
  1password
  adobe-creative-cloud
  chromium
  duckduckgo
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
fi

################################################################################
# Cleanup.
################################################################################

echo "${NAME}: cleaning up ..."

brew cleanup --prune=all
BREW_CACHE="$(brew --cache)"
[ -d "$BREW_CACHE" ] && rm -rf "$BREW_CACHE"

