HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt RM_STAR_SILENT

[ "$PWD" = "$HOME" ] && cd ~/Desktop
START=$'\n'

preexec() {
  TIMER=$(print -P %D{%s%3.})
  _CMD_RUNNING=1
}

_recompute_deps() {
  DEPS="" DEVDEPS=""
  [[ ! -f package.json ]] && return
  local d=0 dd=0 section=""
  while IFS= read -r line; do
    case "$line" in
      *'"devDependencies"'*) section="devdeps"; continue ;;
      *'"dependencies"'*) section="deps"; continue ;;
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
  local _last_exit=$?
  # Default to green if no command has run yet (fresh shell)
  [[ -z "$_CMD_RUNNING" ]] && _last_exit=0
  _CMD_RUNNING=""
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
  local ELAPSED=""
  if [ $TIMER ]; then
    NOW=$(print -P %D{%s%3.})
    local diff=$(($NOW - $TIMER))
    local ms=$((diff % 1000))
    local s=$(((diff / 1000) % 60))
    local m=$(((diff / 1000) / 60))
    if ((m > 0)); then
      ELAPSED="${m}m ${s}s"
    else
      ELAPSED="${s}.${ms}s"
    fi
  fi
  local right="$ELAPSED"
  local padding=""
  if [[ -n "$right" ]]; then
    local left="$USER ${${PWD/#$HOME/~}} $CURRENT_BRANCH$DEPS"
    # Count extra width for emojis (each emoji is 2 cols but ${#} counts 1)
    local emoji_count=$(echo "$left" | grep -o '[📦💠]' | wc -l | tr -d ' ')
    local left_len=$(( ${#left} + emoji_count ))
    local right_len=${#right}
    local pad=$((COLUMNS - left_len - right_len - 1))
    (( pad > 0 )) && padding="${(l:$pad:)}"
  fi
  RPROMPT=""
  local _c="%F{green}"
  (( _last_exit != 0 )) && _c="%F{red}"
  if [[ -n "$ELAPSED" ]]; then
    PROMPT="$START$USER %F{cyan}%~ %F{15}$CURRENT_BRANCH$DEPS$padding${_c}$ELAPSED%f"$'\n'"${_c}%B%(!.#.>)%b%f "
  else
    PROMPT="$START$USER %F{cyan}%~ %F{15}$CURRENT_BRANCH$DEPS"$'\n'"${_c}%B%(!.#.>)%b%f "
  fi
  START=$'\n'
  unset TIMER
}

zshrc() {
  code ~/.zshrc
}
