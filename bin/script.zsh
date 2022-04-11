#!/bin/zsh
mkdir -p ~/.zshify
curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/prompt.zsh | cat >~/.zshify/prompt.zsh
grep "source ~/.zshify/prompt.zsh" ~/.zshrc || echo "source ~/.zshify/prompt.zsh" >>~/.zshrc

echo && which brew &>/dev/null && if [[ "$(uname)" == "Darwin" ]]; then
  brew install gh git rsync zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
elif [[ "$(uname)" == "Linux" ]]; then
  brew install gh git rsync zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
fi

echo "\n$(tput setaf 2)zshify enabled, to reload, run -$(tput sgr0) exec zsh"
