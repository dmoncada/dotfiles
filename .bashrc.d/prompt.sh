# Controlling the prompt:
# https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html

make_prompt()
{
  local RESET="\e[0m"
  local BLACK="\e[0;30m"
  local RED="\e[0;31m"
  local GREEN="\e[0;32m"
  local YELLOW="\e[0;33m"
  local BLUE="\e[0;34m"
  local MAGENTA="\e[0;35m"
  local CYAN="\e[0;36m"
  local WHITE="\e[0;37m"

  local prompt=""
  #local python_exe=$(which python3)

  ## Is the active `python3` a venv executable:
  #if [[ ( ! -z $VIRTUAL_ENV ) && ( $python_exe =~ ^"$VIRTUAL_ENV" ) ]] ; then
  #  local envdir=$(basename $(dirname $VIRTUAL_ENV))
  #  prompt+="\[$GREEN\](venv: $envdir) "

  ## Is the active `python3` a conda executable?
  #elif [[ ( ! -z $CONDA_PREFIX ) && ( $python_exe =~ ^"$CONDA_PREFIX" ) ]] ; then
  #  prompt+="\[$GREEN\](conda: $CONDA_DEFAULT_ENV) "
  #fi

  prompt+="\[$MAGENTA\]\u"
  prompt+="\[$RESET\] in"
  prompt+="\[$BLUE\] \W"

  if git rev-parse --is-inside-work-tree &> /dev/null ; then
    prompt+="\[$RESET\] on"
    prompt+="\[$YELLOW\] $(git rev-parse --short HEAD)"
  fi

  prompt+="\[$RESET\]"
  prompt+="\n\$"

  PS1="$prompt "
}

PROMPT_COMMAND=make_prompt

