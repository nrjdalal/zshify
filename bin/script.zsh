TEMP_DIR=$(mktemp -d)

mkdir -p "$TEMP_DIR/config" && mkdir -p ~/.zshify/config

git clone https://github.com/nrjdalal/zshify.git "$TEMP_DIR" &>/dev/null
curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >"$TEMP_DIR/config/postgres.zsh"
rsync -a --delete "$TEMP_DIR"/ ~/.zshify/

for config in prompt background fx alias plugins user postgres; do
  grep "source ~/.zshify/config/${config}.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/${config}.zsh" >>~/.zshrc
done

echo
echo "-------------- $(tput setaf 2)zshify successfully installed\!$(tput sgr0) --------------"
if ! command -v brew &>/dev/null; then
  echo
  echo "you can't brew without the brew, right? highly recommended\!"
  echo
  echo "--- $(tput setaf 6)/bin/bash -c \"\$(curl -fsSL https://rdt.li/homebrew)\"$(tput sgr0) ---"
fi
echo
echo "it is recommended to reload the shell, run $(tput setaf 3)exec zsh$(tput sgr0) to do so"
echo

[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile

exec zsh
