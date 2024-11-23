eval "$(/opt/homebrew/bin/brew shellenv)"

# nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"

# bun
[ -d ~/.bun/bin ] && PATH=~/.bun/bin:$PATH

# console-ninja
[ -d ~/.console-ninja/.bin ] && PATH=~/.console-ninja/.bin:$PATH
