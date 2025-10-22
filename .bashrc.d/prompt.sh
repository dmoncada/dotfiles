# Controlling the prompt:
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html

make_prompt() {
  local RESET="\e[0m"
  local GREEN="\e[0;32m"
  local YELLOW="\e[0;33m"
  local BLUE="\e[0;34m"
  local MAGENTA="\e[0;35m"

  # shellcheck disable=SC2034  # Unused colors left for completion.
  local BLACK="\e[0;30m"
  # shellcheck disable=SC2034  # Unused colors left for completion.
  local RED="\e[0;31m"
  # shellcheck disable=SC2034  # Unused colors left for completion.
  local CYAN="\e[0;36m"
  # shellcheck disable=SC2034  # Unused colors left for completion.
  local WHITE="\e[0;37m"

  local prompt=""
  local python_exe
  python_exe=$(which python3)

  # Is the active `python3` a venv executable:
  if [ -n "$VIRTUAL_ENV" ] && echo "$python_exe" | grep -q "^$VIRTUAL_ENV" ; then
    prompt+="\[$GREEN\](venv: $VIRTUAL_ENV_PROMPT) "

  # Is the active `python3` a conda executable?
  elif [ -n "$CONDA_PREFIX" ] && echo "$python_exe" | grep -q "^$CONDA_PREFIX" ; then
    prompt+="\[$GREEN\](conda: $CONDA_DEFAULT_ENV) "
  fi

  prompt+="\[$MAGENTA\]\u"
  prompt+="\[$RESET\] in"
  prompt+="\[$BLUE\] \W"

  if git rev-parse --is-inside-work-tree &> /dev/null ; then
    ref=$(git symbolic-ref --quiet --short HEAD)
    if [ -z "$ref" ] ; then
      ref=$(git rev-parse --short HEAD)
    fi

    prompt+="\[$RESET\] on"
    prompt+="\[$YELLOW\] $ref"
  fi

  prompt+="\[$RESET\]"
  prompt+="\n\$"

  PS1="$prompt "
}

PROMPT_COMMAND=make_prompt

