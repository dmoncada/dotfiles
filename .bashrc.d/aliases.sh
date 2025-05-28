################################################################################
# Aliases
################################################################################

# Colorized output.
alias grep='grep --color'

# Replacement for `ls`.
if which -a eza > /dev/null ; then
  alias ls='eza --almost-all --classify --color=always --group-directories-first --icons=always'
  alias ll='ls --binary --git --group --long'
  alias t='ls --tree --git-ignore'

elif which -a lsd > /dev/null ; then
  alias ls='lsd --almost-all --classify --color=always --group-dirs=first'
  alias ll='ls --date="+%d %b %Y" --long'

elif [ -f  /usr/local/opt/coreutils/libexec/gnubin/ls ] ; then
  alias ls='ls --almost-all --classify --color=always --group-directories-first'
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

# Builds intermediate dirs.
alias mkdir='mkdir -p'

# Reloads the bash config. file.
alias resource='[ -f ~/.bashrc ] && source ~/.bashrc'

# Go up one directory.
alias ..='cd ..'

# Prints each `PATH` entry on a separate line.
alias path='echo $PATH | tr -s ":" "\n"'

# Prints your local ip address.
alias showip='curl --silent ipinfo.io | jq --raw-output ".ip"'

# Define macOS-only aliases.
if [ "$(uname)" = "Darwin" ] ; then
    # Recursively delete `.DS_Store` files.
    alias cleands='find . -type f -name ".*DS_Store" -ls -delete'

    # Show/hide hidden files in Finder.
    alias show='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
    alias hide='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

    # Toggle dark mode.
    alias toggledark='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"'
fi

