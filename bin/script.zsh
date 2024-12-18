#!/bin/zsh
mkdir -p ~/.zshify

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/prompt.zsh | cat >~/.zshify/prompt.zsh
grep "source ~/.zshify/prompt.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/prompt.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/profile.zsh | cat >~/.zshify/profile.zsh
curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/background.zsh | cat >~/.zshify/background.zsh
grep "source ~/.zshify/background.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/background.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/fx.zsh | cat >~/.zshify/fx.zsh
grep "source ~/.zshify/fx.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/fx.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/alias.zsh | cat >~/.zshify/alias.zsh
grep "source ~/.zshify/alias.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/alias.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/plugins.zsh | cat >~/.zshify/plugins.zsh
grep "source ~/.zshify/plugins.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/plugins.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/user.zsh | cat >~/.zshify/user.zsh
grep "source ~/.zshify/user.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/user.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >~/.zshify/postgres.zsh
grep "source ~/.zshify/postgres.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/postgres.zsh" >>~/.zshrc

which brew &>/dev/null || echo "\n$(tput setaf 1)brew not installed! install via -$(tput sgr0)\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\"

echo "\n$(tput setaf 2)zshify enabled! to reload, run -$(tput sgr0) exec zsh"

# cleanup

[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile
