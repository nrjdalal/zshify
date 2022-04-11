#!/bin/zsh
mkdir -p ~/.zshify
curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/prompt.zsh | cat >~/.zshify/prompt.zsh
grep "source ~/.zshify/prompt.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/prompt.zsh" >>~/.zshrc

which brew &>/dev/null || echo "\n$(tput setaf 1)brew not installed! install via -$(tput sgr0)\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\"

echo "\n$(tput setaf 2)zshify enabled, to reload, run -$(tput sgr0) exec zsh"
