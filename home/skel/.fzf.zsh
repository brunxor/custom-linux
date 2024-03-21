# Setup fzf
# ---------
if [[ ! "$PATH" == */home/brunxor/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/brunxor/.fzf/bin"
fi

eval "$(fzf --zsh)"
