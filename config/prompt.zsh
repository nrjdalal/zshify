HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt RM_STAR_SILENT

[ "$PWD" = "$HOME" ] && cd ~/Desktop
# newline before prompt unless fresh terminal
START=$'\n'
if [[ -z "$_ZSHIFY_STARTED" ]]; then
  START=""
  _ZSHIFY_STARTED=1
fi

preexec() {
  TIMER=$(print -P %D{%s%3.})
  _CMD_RUNNING=1
  _LAST_CMD="$1"
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
  # default to green if no command has run yet (fresh shell)
  [[ -z "$_CMD_RUNNING" ]] && _last_exit=0
  _CMD_RUNNING=""
  # recompute deps when directory or package.json changes
  local _pkg_mtime=$(stat -f %m package.json 2>/dev/null)
  if [[ "$PWD" != "$_PROMPT_LAST_PWD" || "$_pkg_mtime" != "$_PROMPT_LAST_PKG" ]]; then
    _PROMPT_LAST_PWD="$PWD"
    _PROMPT_LAST_PKG="$_pkg_mtime"
    _recompute_deps
  fi
  # git info (branch, ahead/behind, stash)
  CURRENT_BRANCH=""
  local GIT_INFO=""
  local git_dir=$(command git rev-parse --git-dir 2>/dev/null)
  if [[ -n "$git_dir" ]]; then
    # branch from HEAD file (no fork)
    local head=$(<"$git_dir/HEAD")
    [[ "$head" == ref:\ * ]] && CURRENT_BRANCH="${head#ref: refs/heads/}"
    # ahead/behind
    local ab=$(command git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
    if [[ -n "$ab" ]]; then
      local ahead=${ab%%$'\t'*}
      local behind=${ab##*$'\t'}
      (( ahead > 0 )) && GIT_INFO+=" ↑$ahead"
      (( behind > 0 )) && GIT_INFO+=" ↓$behind"
    fi
    # stash count (pure file read, no fork)
    if [[ -f "$git_dir/logs/refs/stash" ]]; then
      local stash_count=0
      while IFS= read -r _; do ((stash_count++)); done < "$git_dir/logs/refs/stash"
      (( stash_count > 0 )) && GIT_INFO+=" ≡$stash_count"
    fi
    # file status (unstaged: untracked/modified/deleted, staged: added/modified/deleted)
    local s_add=0 s_mod=0 s_del=0 w_new=0 w_mod=0 w_del=0
    while IFS= read -r line; do
      case "${line:0:2}" in
        \?\?) ((w_new++)) ;;
        *)
          case "${line:0:1}" in
            A|?) ;& [!\ ]) [[ "${line:0:1}" == "A" ]] && ((s_add++));
              [[ "${line:0:1}" == "M" ]] && ((s_mod++));
              [[ "${line:0:1}" == "D" ]] && ((s_del++));
              [[ "${line:0:1}" == "R" ]] && ((s_mod++));;
          esac
          [[ "${line:1:1}" == "M" ]] && ((w_mod++))
          [[ "${line:1:1}" == "D" ]] && ((w_del++))
          ;;
      esac
    done < <(command git status --porcelain 2>/dev/null)
    # unstaged
    (( w_new > 0 )) && GIT_INFO+=" %F{green}•%f$w_new"
    (( w_mod > 0 )) && GIT_INFO+=" %F{yellow}•%f$w_mod"
    (( w_del > 0 )) && GIT_INFO+=" %F{red}•%f$w_del"
    # staged in parentheses
    local _staged=""
    (( s_add > 0 )) && _staged+="%F{green}•%f$s_add"
    (( s_mod > 0 )) && { [[ -n "$_staged" ]] && _staged+=" "; _staged+="%F{yellow}•%f$s_mod"; }
    (( s_del > 0 )) && { [[ -n "$_staged" ]] && _staged+=" "; _staged+="%F{red}•%f$s_del"; }
    [[ -n "$_staged" ]] && GIT_INFO+=" ($_staged)"
  fi
  [[ "$_LAST_CMD" == "clear" ]] && START=""
  # set prompt with user, directory, branch, and dependencies
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
    local left="$USER ${${PWD/#$HOME/~}} $CURRENT_BRANCH$DEPS$GIT_INFO"
    # count extra width for emojis (each emoji is 2 cols but ${#} counts 1)
    local emoji_count=0
    [[ "$left" == *📦* ]] && ((emoji_count++))
    [[ "$left" == *💠* ]] && ((emoji_count++))
    local left_len=$(( ${#left} + emoji_count ))
    local right_len=${#right}
    local pad=$((COLUMNS - left_len - right_len - 1))
    (( pad > 0 )) && padding="${(l:$pad:)}"
  fi
  RPROMPT=""
  local _c="%F{green}"
  (( _last_exit != 0 )) && _c="%F{red}"
  if [[ -n "$ELAPSED" ]]; then
    PROMPT="$START$USER %F{cyan}%~ %F{15}$CURRENT_BRANCH$DEPS$GIT_INFO$padding${_c}$ELAPSED%f"$'\n'"${_c}%B%(!.#.>)%b%f "
  else
    PROMPT="$START$USER %F{cyan}%~ %F{15}$CURRENT_BRANCH$DEPS$GIT_INFO"$'\n'"${_c}%B%(!.#.>)%b%f "
  fi
  START=$'\n'
  unset TIMER
}

zshrc() {
  code ~/.zshrc
}
