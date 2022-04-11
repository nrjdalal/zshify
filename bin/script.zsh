#!/bin/zsh
mkdir -p ~/.zshify
curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/prompt.zsh | cat >~/.zshify/prompt.zsh

grep "source ~/.zshify/prompt.zsh" ~/.zshrc || echo "source ~/.zshify/prompt.zsh" >>~/.zshrc

echo
echo "zshify enabled, to reload, run -"
echo "exec zsh"
