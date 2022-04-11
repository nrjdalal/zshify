#!/bin/zsh
cat >>~.zshrc <<ZSHRC
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY_TIME
setopt RM_STAR_SILENT

preexec() {
  TIMER=$(print -P %D{%s%3.})
}

precmd() {
  CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
  NEWLINE=$'\n'
  PROMPT="$newline%F{cyan}%~ %F{white}$CURRENT_BRANCH$NEWLINE%(?.%F{green}.%F{red})%B%(!.#.>)%b%f "
  newline=$NEWLINE
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
  unset TIMER
}

# aliases
alias zshrc='code ~/.zshrc'

# make and change to directory
cdx() {
  mkdir -p $1 && cd $1
}

# better listing
lsx() {
  tree --filesfirst -aCL 1 | sed -e 's/├── //g' -e 's/└── //g' | tail -n +2
}

# create github repository, pass --private to create private repository
mkrepo() {
  command git init
  command git add -A 2>/dev/null
  command git commit -m "$(date)" 2>/dev/null

  if [[ "$#" == "0" ]]; then
    command gh repo create $(basename $(pwd)) -d '' --push -s . --public
  else
    command gh repo create $(basename $(pwd)) -d '' --push -s . "$@"
  fi
}

# git add & git commit at once | git push
@git() {
  if [[ "$#" == "0" ]]; then
    command git add -A 2>/dev/null
    command git commit -m "$(date)" 2>/dev/null
    command git push
  elif [[ "$#" == "1" ]]; then
    command git add -A 2>/dev/null
    command git commit -m "$1" 2>/dev/null
    command git push
  fi
}

# manage npm packages using yarn (just add @ in front of npm)
@npm() {
  if [[ "$1" == "install" ]]; then
    command yarn add ${@:2}
  elif [[ "$1" == "uninstall" ]]; then
    command yarn remove ${@:2}
  fi
}

# kill pid by port
close() {
  lsof -i :$1 | awk '{print $2}' | tail +2 | xargs kill -9
}

# rename current working dir or an existing folder
rename() {
  if [[ "$#" == "1" ]]; then
    command [ ! -d "../$1/" ] && rsync -a "$(pwd)/" "../$1" && rm -rf "$(pwd)/" && cd "../$1/"
    if [[ $? == 0 && "$TERM_PROGRAM" == "vscode" ]]; then
      code -r .
    fi
  elif [[ "$#" == "2" ]]; then
    command [ ! -d "$2/" ] && rsync -a "$1/" "$2" && rm -rf "$1/"
  else
    command echo "Usage:"
    command echo " rename new_dirname         ~ renames current working dir"
    command echo " rename dirname new_dirname ~ renames existing dir to new"
  fi
}

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bg=#000000,fg=#333333"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold,underline"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold,underline"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

echo "Hello"
ZSHRC
