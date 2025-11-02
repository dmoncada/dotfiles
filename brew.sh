#!/usr/bin/env bash

set -euo pipefail

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
if which brew &> /dev/null ; then # update it.
  echo "${NAME}: updating and upgrading homebrew ..."
  brew update
  brew upgrade

else # install and diagnose.
  echo "${NAME}: installing homebrew ..."
  if ! bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" ; then
    echo "${NAME}: the installation was aborted ..."
    exit 1
  fi

  try_init_brew "/opt/homebrew"

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
make
stow
binutils
coreutils
diffutils
findutils
curl
bat
csvkit
fzf
git
glow
jq
micromamba
"python@3.14"
shellcheck
vim
watch
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
duckduckgo
font-cascadia-code
git-credential-manager
itsycal
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
[ -d "$BREW_CACHE" ] && rm -rf "$BREW_CACHE"

