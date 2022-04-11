#!/bin/zsh
curl -s https://raw.githubusercontent.com/nrjdalal/mac-setup/main/.zshrc | cat >~/.zshrc

echo
echo ".zshrc config add, to reload, run -"
echo "exec zsh"
