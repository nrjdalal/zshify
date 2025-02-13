# zsh-autosuggestions
if [ -s "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="bg=#000000,fg=#333333"
fi

# zsh-syntax-highlighting
if [ -s "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# zsh-history-substring-search
if [ -s "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
  source "/opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=green,bold,underline"
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=red,bold,underline"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi
