alias is_linux='[ "$(uname)" = "Linux" ]'
alias is_macos='[ "$(uname)" = "Darwin" ]'

try_init_brew() {
  local prefix="$1"
  if [ -e "$prefix"/bin/brew ] ; then
    eval "$("$prefix"/bin/brew shellenv)"
  fi
}

# Load brew.
try_init_brew "/opt/homebrew"
try_init_brew "/home/linuxbrew/.linuxbrew"

# Load startup files.
for file in ~/.bashrc.d/*.sh ; do
  source "$file"
done
unset file

BREW_PREFIX="$(brew --prefix)"
path_prepend "${BREW_PREFIX}/opt/coreutils/libexec/gnubin"
path_prepend "${BREW_PREFIX}/opt/findutils/libexec/gnubin"
path_prepend "${BREW_PREFIX}/opt/make/libexec/gnubin"
path_prepend "${BREW_PREFIX}/opt/curl/bin"

# Load cargo.
[ -f ~/.cargo/env ] && source ~/.cargo/env

# Set up `fzf`.
which fzf &> /dev/null && eval "$(fzf --bash)"

# Set colors for `ls`, `lsd`, `eza`, etc.
[ -f ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

# Use `bat` as the pager for `man`.
export MANPAGER="sh -c 'col -bx | bat --plain --language=man'"

# Do not send analytics.
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

# Opt out of `dotnet`'s telemetry.
# export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Cycle through files with tab/shift + tab.
# See: https://superuser.com/a/59198
[[ $- = *i* ]] && bind TAB:menu-complete
bind '"\e[Z":menu-complete-backward'

# Delete word with ctrl + backspace.
# Needs: "Send Hex Codes: 0x17" mapped to ctrl + backspace in iTerm2.
# See: https://github.com/microsoft/terminal/issues/755#issuecomment-541119165
bind '"\C-h":backward-kill-word'
# bind '"\C-w":backward-kill-word'

