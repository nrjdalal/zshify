#!/bin/zsh
mkdir -p ~/.zshify
curl -s https://raw.githubusercontent.com/nrjdalal/mac-setup/main/.zshrc | cat >~/.zshify/prompt.zsh

echo
echo ".zshrc config add, to reload, run -"
echo "exec zsh"
