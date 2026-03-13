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

_recompute_deps() {
  DEPS="" DEVDEPS=""
  [[ ! -f package.json ]] && return
  local d=0 dd=0 section=""
  while IFS= read -r line; do
    case "$line" in
      *'"dependencies"'*) section="deps"; continue ;;
      *'"devDependencies"'*) section="devdeps"; continue ;;
      *'}'*) section=""; continue ;;
    esac
    if [[ -n "$section" && "$line" == *'": '* ]]; then
      [[ "$section" == "deps" ]] && ((d++))
      [[ "$section" == "devdeps" ]] && ((dd++))
    fi
  done < package.json
  (( d > 0 )) && DEPS=" 📦$d" || DEPS=""
  (( dd > 0 )) && DEVDEPS=" 💠$dd" || DEVDEPS=""
  DEPS="$DEVDEPS$DEPS"
}

precmd() {
  # Recompute deps when directory or package.json changes
  local _pkg_mtime=$(stat -f %m package.json 2>/dev/null)
  if [[ "$PWD" != "$_PROMPT_LAST_PWD" || "$_pkg_mtime" != "$_PROMPT_LAST_PKG" ]]; then
    _PROMPT_LAST_PWD="$PWD"
    _PROMPT_LAST_PKG="$_pkg_mtime"
    _recompute_deps
  fi
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
