# Controlling the prompt:
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html

make_prompt() {
  local RESET="\e[0m"
  local GREEN="\e[0;32m"
  local YELLOW="\e[0;33m"
  local BLUE="\e[0;34m"
  local MAGENTA="\e[0;35m"

  # Unused colors, left for completion.
  # local BLACK="\e[0;30m"
  # local RED="\e[0;31m"
  # local CYAN="\e[0;36m"
  # local WHITE="\e[0;37m"

  local prompt=""

  if [ -n "$CONDA_PREFIX" ] ; then
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

