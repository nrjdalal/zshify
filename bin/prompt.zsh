#!/bin/zsh
echo >>~/.zshrc
echo 'PROMPT="%(?.%F{green}.%F{red})%B%~ %(!.#.>)%b%f "' >>~/.zshrc
echo
/bin/zsh
