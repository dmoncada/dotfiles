if is_macos ; then
  clip() {
    if [ ! -t 0 ]; then
        pbcopy
    else
        pbpaste
    fi
  }
fi

dui() {
  if [ $# -gt 1 ] ; then
    echo "Usage: ${FUNCNAME[0]} [FILE]" >&2
    return 1
  fi

  local dir=${1:-.}
  du -ah -d 1 "$dir" | sort -hr | column -t | bat -p
}

filesize() {
  if [ $# -ne 1 ] ; then
    echo "Usage: ${FUNCNAME[0]} FILE" >&2
    return 1
  fi

  if [ -e "$1" ] ; then
    stat --format=%s "$1" | numfmt --to=iec --suffix=B
    return 0
  fi

  echo "${FUNCNAME[0]}: cannot ${FUNCNAME[0]} '$1': No such file or directory." >&2
  return 1
}

git() {
  local git_bin=""
  git_bin="$(command -v git)"

  if [ "$git_bin" = "$0" ]; then
    echo "Error: git binary not found." >&2
    return 1
  fi

  if [ "$#" -eq 0 ] ; then
    command "$git_bin" status
    return
  fi

  if [ "$#" -eq 1 ] && [ "$1" = "root" ] ; then
    local root=""
    root="$("$git_bin" rev-parse --show-toplevel 2> /dev/null)" || {
      echo "Not inside a git repository." >&2
      return 1
    }
    cd "$root" || {
      echo "Failed to cd into $root" >&2
      return 1
    }
    return
  fi

  command "$git_bin" "$@"
}

conda() {
  if ! command -v micromamba >/dev/null 2>&1; then
    echo "${FUNCNAME[0]}: conda: command not found." >&2
    return 127
  fi

  if [ -z "$CONDA_DEFAULT_ENV" ] ; then
    eval "$(micromamba shell hook --shell "$(basename "${SHELL}")")"
    micromamba activate
  else
    micromamba "$@"
  fi
}

json() {
  if [ -t 0 ] && [ "$#" -gt 0 ]; then
    jq --color-output . "$@" | $PAGER
  else
    jq --color-output "$@" | $PAGER
  fi
}

help() {
  "$@" --help 2>&1 | bat --language=help
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
  if [ "$(echo "$PATH" | tr -s ":" "\n" | grep "$dir" | uniq | wc -l)" -ge 1 ] ; then
    return
  fi

  case "$action" in
    append)
      export PATH="$PATH:$dir"
      ;;
    prepend)
      export PATH="$dir:$PATH"
      ;;
    *)
      echo "${FUNCNAME[0]}: invalid action '$action'." >&2
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
