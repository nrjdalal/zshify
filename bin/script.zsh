#!/bin/zsh
mkdir -p ~/.zshify

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/prompt.zsh | cat >~/.zshify/config/prompt.zsh
grep "source ~/.zshify/config/prompt.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/prompt.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/profile.zsh | cat >~/.zshify/config/profile.zsh
curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/background.zsh | cat >~/.zshify/config/background.zsh
grep "source ~/.zshify/config/background.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/background.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/fx.zsh | cat >~/.zshify/config/fx.zsh
grep "source ~/.zshify/config/fx.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/fx.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/alias.zsh | cat >~/.zshify/config/alias.zsh
grep "source ~/.zshify/config/alias.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/alias.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/plugins.zsh | cat >~/.zshify/config/plugins.zsh
grep "source ~/.zshify/config/plugins.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/plugins.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/zshify/master/config/user.zsh | cat >~/.zshify/config/user.zsh
grep "source ~/.zshify/config/user.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/user.zsh" >>~/.zshrc

curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >~/.zshify/config/postgres.zsh
grep "source ~/.zshify/config/postgres.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/postgres.zsh" >>~/.zshrc

which brew &>/dev/null || echo "\n$(tput setaf 1)brew not installed! install via -$(tput sgr0)\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\"

echo "\n$(tput setaf 2)zshify enabled! to reload, run -$(tput sgr0) exec zsh"

# cleanup

[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile
