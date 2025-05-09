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
  brew update
  brew upgrade

else # install and diagnose.
  echo "${NAME}: installing homebrew ..."
  $(which bash) -c $(curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install.sh")

  if [ "$?" -ne 0 ] ; then
    echo "${NAME}: the installation was aborted ..."
    exit 1
  fi

  echo "${NAME}: disabling analytics ..."
  brew analytics off

  echo "${NAME}: diagnosing homebrew ..."
  brew doctor

  # echo "${NAME}: tapping formulae repositories ..."
  # brew tap homebrew/bundle
  # brew tap homebrew/cask
  # brew tap homebrew/cask-drivers # For DisplayLink; update 2024-08-03: deprecated!
  # brew tap homebrew/cask-versions # Update 2024-08-03: deprecated!
  # brew tap homebrew/core
  # brew tap mongodb/brew # For mongoDB Community Edition.
  # brew tap microsoft/git # For git-credential-manager-core.
fi

################################################################################
# Formulae.
################################################################################

BREW_PREFIX="$(brew --prefix)"

brew install bash # Newer version, keg-only.
if [ "$SHELL" != "${BREW_PREFIX}/bin/bash" ] ; then
  echo "${NAME}: changing shell: $SHELL -> ${BREW_PREFIX}/bin/bash ..."
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
  chsh -s "${BREW_PREFIX}/bin/bash"
fi

# GNU software.
brew install coreutils # Newer version, keg-only.
brew install diffutils
brew install findutils
# brew install gawk
# brew install gnu-sed
# brew install grep # --with-default-names
# brew install gzip
brew install make # Newer version, keg-only.

# Misc. formulae.
# brew install azure-cli
brew install bat
# brew install cmake
# brew install ctags
# brew install curl # Newer version than system curl, keg-only.
# brew install dos2unix unix2dos
# brew install doxygen
# brew install fzf && "$(brew --prefix)/opt/fzf/install"
brew install git # Newer version than system git.
# brew install git-lfs
# brew install go
brew install jq
# brew install llvm # Contains newer version than system clang/clang++. For YCM.
# brew install nvm # && nvm install --lts
# brew install node
# brew install node@16 && brew link --overwrite node@16 && npm install --global yarn
# brew install openjdk
# brew install pass
brew install python
# brew install reattach-to-user-namespace
# brew install tmux
# brew install tree
brew install vim # --with-override-system-vi
brew install wget # Surprisingly, it does not come with macOS.
# brew install yarn # Install with: $ npm install --global yarn

# Rust.
# curl --proto "=https" --tlsv1.2 -sSf "https://sh.rustup.rs" | sh

################################################################################
# Casks.
################################################################################

brew install --cask 1password
# brew install --cask android-studio
# brew install --cask adobe-acrobat-reader
brew install --cask adobe-creative-cloud
# brew install --cask alfred
# brew install --cask basictex
brew install --cask chromium
# brew install --cask displaylink
# brew install --cask displaylink-login-extension
# brew install --cask docker
# brew install --cask dotnet-sdk
# brew --cask install duet # Not sure I need this anymore...
brew install --cask font-cascadia-code
# brew install --cask lulu
# brew install --cask iterm2
brew install --cask itsycal
# brew install --cask microsoft-edge
# brew install --cask microsoft-office
# brew install --cask microsoft-teams
# brew install --cask miniconda
brew install --cask monitorcontrol
# brew install --cask mono-mdk
# brew install --cask pluralsight
# brew install --cask postman
# brew install --cask signal
# brew install --cask skim
# brew install --cask sourcetree
# brew install --cask teamviewer
# brew install --cask the-unarchiver
# brew install --cask unity-hub
# brew install --cask virtualbox
# brew install --cask visual-studio
# brew install --cask visual-studio-code
# brew install --cask whatsapp

################################################################################
# Cleanup
################################################################################

echo "${NAME}: cleaning up..."
brew cleanup --prune=all

