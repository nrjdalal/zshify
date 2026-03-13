# bun
[ -d ~/.bun/bin ] && PATH=~/.bun/bin:$PATH

# corepack
export COREPACK_ENABLE_AUTO_PIN=0

# fnm
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
