eval "$(/opt/homebrew/bin/brew shellenv)"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/Users/nrjdalal/.bun/_bun" ] && source "/Users/nrjdalal/.bun/_bun"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

source $(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh &>/dev/null
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bg=#000000,fg=#333333"

source $(brew --prefix 2>/dev/null)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh &>/dev/null

source $(brew --prefix 2>/dev/null)/share/zsh-history-substring-search/zsh-history-substring-search.zsh &>/dev/null
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold,underline"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold,underline"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

source <(fzf --zsh) &>/dev/null

eval "$(zoxide init zsh --cmd cd)" &>/dev/null

PATH=~/.console-ninja/.bin:$PATH
