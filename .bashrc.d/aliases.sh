# Replacement for `ls`.
if which gls > /dev/null 2>&1 ; then
  alias ls='gls --almost-all --classify --color=always --group-directories-first'
  alias ll='ls -l --human-readable'

else # System `ls`.
  alias ls='ls -AF --color=always'
  alias ll='ls -lHh'
fi

alias l='ll'

# Forces confirmation.
alias rm='rm -i'

# Verbose output.
alias mv='mv -i -v'
alias cp='cp -i -v'
alias ln='ln -i -v'

# Colorized output.
alias grep='grep --color'

# # Quit if content fits one page.
# alias less='less -FRS'

# Builds intermediate dirs.
alias mkdir='mkdir -p'

# Reloads the bash config. file.
alias resource='[ -f ~/.bashrc ] && source ~/.bashrc'

# Go up one directory.
alias ..='cd ..'

# Prints each `PATH` entry on a separate line.
alias path='echo $PATH | tr -s ":" "\n"'

# Prints the current Unix timestamp.
alias unixtime='date +%s'

# Prints your local ip address.
alias ip='curl --silent ipconfig.io/json | jq --raw-output ".ip"'

alias loc='curl --silent ipconfig.io/json | jq --monochrome-output "{lat: .latitude, lon: .longitude}"'

# Define macOS-only aliases.
if is_macos ; then
    # Recursively delete `.DS_Store` files.
    alias cleands='find . -type f -name ".*DS_Store" -ls -delete'

    # Show/hide hidden files in Finder.
    alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
    alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

    # Toggle dark mode.
    alias toggledark='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"'

    # Print URLs for each tab in Safari.
    alias safaritabs='osascript -e '\''tell application "Safari" to get URL of every tab of every window'\'' | tr "," "\n" | sed "s/^[[:space:]]*//"'
fi
