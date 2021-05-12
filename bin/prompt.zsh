#!/bin/zsh
curl https://rdt.li/PdJ138
echo >>~/.zshrc
echo 'PROMPT="%(?.%F{green}.%F{red})%B%~ %(!.#.>)%b%f "' >>~/.zshrc
echo
/bin/zsh
