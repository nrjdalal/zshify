# nvm
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && source "/opt/homebrew/opt/nvm/nvm.sh"

# fzf
command -v fzf &>/dev/null && source <(fzf --zsh)

# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd cd)"

# bun
[ -d ~/.bun/bin ] && PATH=~/.bun/bin:$PATH

# bun completions
[ -s ~/.bun/_bun ] && source ~/.bun/_bun

# console-ninja
[ -d ~/.console-ninja/.bin ] && PATH=~/.console-ninja/.bin:$PATH

# python
[ -d ~/Library/Python/3.9/bin ] && PATH="~/Library/Python/3.9/bin:$PATH"
