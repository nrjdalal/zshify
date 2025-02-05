HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt RM_STAR_SILENT

[ "$PWD" = "$HOME" ] && cd ~/Desktop

preexec() {
  TIMER=$(print -P %D{%s%3.})
}

precmd() {
  # if [ $? -ne 0 ]; then
  #   run a command if the last command failed
  # fi
  # get the number of dependencies in package.json
  DEPS=$(jq '.dependencies | length' package.json 2>/dev/null)
  DEPS=$([ "$DEPS" -eq 0 ] 2>/dev/null && echo "" || echo " 📦$DEPS")
  # get the current branch
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
  [[ "$(fc -ln -1)" == "clear" ]] && START=""
  # set the prompt to the current user, directory, branch, and dependencies
  PROMPT="$START$USER %F{cyan}%~ %F{15}$CURRENT_BRANCH$DEPS"$'\n'"%(?.%F{green}.%F{red})%B%(!.#.>)%b%f "
  if [ $TIMER ]; then
    NOW=$(print -P %D{%s%3.})
    local diff=$(($NOW - $TIMER))
    local ms=$((diff % 1000))
    local s=$(((diff / 1000) % 60))
    local m=$(((diff / 1000) / 60))
    if ((m > 0)); then
      local ELAPSED="${m}m ${s}s"
    else
      local ELAPSED="${s}.${ms}s"
    fi
    RPROMPT="%(?.%F{green}.%F{red})${ELAPSED}%f"
  fi
  START=$'\n'
  unset TIMER
}

zshrc() {
  code ~/.zshrc
}
