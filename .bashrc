# Load startup files.
for file in ~/.bashrc.d/*.sh ; do
  source "$file"
done
unset file

# Load cargo.
[ -f ~/.cargo/env ] && source ~/.cargo/env

# Load miniconda.
if which -s conda ; then
  eval "$(conda "shell.$(basename "${SHELL}")" hook)"
fi

# Override default Unix commands with their GNU counterparts (homebrew).
path_prepend "/usr/local/opt/coreutils/libexec/gnubin"
path_prepend "/usr/local/opt/findutils/libexec/gnubin"
path_prepend "/usr/local/opt/make/libexec/gnubin"

# Opt out of `dotnet`'s telemetry.
# DOTNET_CLI_TELEMETRY_OPTOUT=1

# Cycle through files with tab/shift + tab.
# See: https://superuser.com/a/59198
[[ $- = *i* ]] && bind TAB:menu-complete
bind '"\e[Z":menu-complete-backward'

# Delete word with ctrl + backspace.
# Needs: "Send Hex Codes: 0x17" mapped to ctrl + backspace in iTerm2.
# See: https://github.com/microsoft/terminal/issues/755#issuecomment-541119165
bind '"\C-h":backward-kill-word'
# bind '"\C-w":backward-kill-word'

# Set colors for `ls`, `lsd`, `eza`, etc.
[ -f ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

# Use `bat` as the pager for `man`.
export MANPAGER="sh -c 'col -bx | _bat --plain --language=man'"

