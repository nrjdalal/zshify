# zsh-autosuggestions
[ -s "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bg=#000000,fg=#333333"

# zsh-syntax-highlighting
[ -s "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# zsh-history-substring-search
[ -s "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && source "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold,underline"
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold,underline"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
