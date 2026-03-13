# bun
[ -d ~/.bun/bin ] && PATH=~/.bun/bin:$PATH

# corepack
export COREPACK_ENABLE_AUTO_PIN=0

# fnm
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# local
[ -d ~/.local/bin ] && PATH=~/.local/bin:$PATH

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# If command not found, try zoxide cd
if command -v zoxide &>/dev/null && [[ -o interactive ]] && [[ -o zle ]]; then
  _zoxide_accept_line() {
    local cmd="${BUFFER%% *}"
    if [[ -n "$cmd" ]] && ! whence "$cmd" &>/dev/null; then
      local dir=$(zoxide query "$cmd" 2>/dev/null)
      if [[ -n "$dir" ]]; then
        BUFFER="cd ${(q)dir}"
      fi
    fi
    zle .accept-line
  }
  zle -N accept-line _zoxide_accept_line
fi
