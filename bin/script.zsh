#!/bin/zsh

temp_dir=$(mktemp -d)
git clone https://github.com/nrjdalal/zshify.git "$temp_dir" &>/dev/null
curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >"$temp_dir/config/postgres.zsh"
mkdir -p ~/.zshify
rsync -a --delete "$temp_dir"/ ~/.zshify/
rm -rf "$temp_dir"

for config in prompt background fx alias plugins user postgres; do
  grep "source ~/.zshify/config/${config}.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/${config}.zsh" >>~/.zshrc
done

echo
echo "-------------- $(tput setaf 2)zshify successfully installed\!$(tput sgr0) --------------"
if ! command -v brew &>/dev/null; then
  echo
  echo "you can't brew without the brew, right? hightly recommended\!"
  echo
  echo "--- $(tput setaf 6)/bin/bash -c \"\$(curl -fsSL https://rdt.li/homebrew)\"$(tput sgr0) ---"
fi
echo
echo "it is recommended to reload the shell, run $(tput setaf 3)exec zsh$(tput sgr0) to do so"
echo

[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile

exec zsh
