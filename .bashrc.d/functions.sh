_bat() {
  THEME="Solarized (light)"

  if defaults read -globalDomain AppleInterfaceStyle &> /dev/null ; then
    THEME="Solarized (dark)"
  fi

  $(which bat) --theme="$THEME" "$@"
}

# Make this function available to sub-shells.
export -f _bat

# Refer to this function with `bat`.
alias bat=_bat

clip() {
  # Triggered when some program's output is piped to this function.
  # Ex: $ echo "Hello, world!" | clip
  # Ex: $ cat some.file | clip
  if [ -p /dev/stdin ] ; then
    cat | pbcopy

  # Triggered when some file's contents are redirected to this function.
  # Ex: $ clip < some.file
  elif [ ! -t 0 ] ; then
    cat | pbcopy

  # Triggered when this function's output is piped to some program.
  # Ex: $ clip | cat
  elif [ -p /dev/stdout ] ; then
    pbpaste

  # Triggered when this function's output is redirected to some file.
  # Ex: $ clip > some.file
  elif [ ! -t 1 ] ; then
    pbpaste

  # Triggered when the function is invoked with no arguments; will print the
  # contents of the clipboard to the terminal.
  # Ex: $ clip
  else
    pbpaste
  fi
}

dui() {
  if [ $# -gt 1 ] ; then
    >&2 echo "Usage: ${FUNCNAME[0]} [FILE]"
    return 1
  fi

  local dir=${1:-.}
  du -ah -d 1 "$dir" | sort -hr | column -t | bat -p
}

filesize() {
  if [ $# -ne 1 ] ; then
    >&2 echo "Usage: ${FUNCNAME[0]} FILE"
    return 1
  fi

  if [ -e $1 ] ; then
    stat --format=%s $1 | numfmt --to=iec --suffix=B
    return 0
  fi

  >&2 echo "${FUNCNAME[0]}: cannot ${FUNCNAME[0]} '$1': No such file or directory."
  return 1
}

_git_wrap() {
  GIT_BIN=$(which git)

  if [ $# -eq 0 ] ; then
    $GIT_BIN status
    return 0
  fi

  $GIT_BIN "$@"
}
alias git=_git_wrap

help() {
  "$@" --help 2>&1 | _bat --plain --language=help
}

add_to_path() {
  local dir="$1"
  local action="$2"

  # Check if the directory exists.
  if [ ! -e "$dir" ] ; then
    >&2 echo "${FUNCNAME[0]}: cannot ${FUNCNAME[0]} '$dir': No such directory."
    return 1
  fi

  # Check if the directory is already in the PATH.
  if [ $(echo "$PATH" | tr -s ":" "\n" | grep "$dir" | uniq | wc -l) -ge 1 ] ; then
    return 0
  fi

  case "$action" in
    append)
      export PATH="$PATH:$dir"
      ;;
    prepend)
      export PATH="$dir:$PATH"
      ;;
    *)
      >&2 echo "${FUNCNAME[0]}: invalid action '$action'."
      return 1
      ;;
  esac
}

path_append() {
  add_to_path "$1" "append"
}

path_prepend() {
  add_to_path "$1" "prepend"
}

