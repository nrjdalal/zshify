#!/bin/zsh
mkdir -p ~/.zshify

# Clone the repository
git clone https://github.com/nrjdalal/zshify.git ~/.zshify

# Source the configuration files in ~/.zshrc
grep "source ~/.zshify/config/prompt.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/prompt.zsh" >>~/.zshrc
grep "source ~/.zshify/config/background.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/background.zsh" >>~/.zshrc
grep "source ~/.zshify/config/fx.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/fx.zsh" >>~/.zshrc
grep "source ~/.zshify/config/alias.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/alias.zsh" >>~/.zshrc
grep "source ~/.zshify/config/plugins.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/plugins.zsh" >>~/.zshrc
grep "source ~/.zshify/config/user.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/user.zsh" >>~/.zshrc

# Download the postgres script separately
curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >~/.zshify/config/postgres.zsh
grep "source ~/.zshify/config/postgres.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/postgres.zsh" >>~/.zshrc

# Check if Homebrew is installed
which brew &>/dev/null || echo "\n$(tput setaf 1)brew not installed! install via -$(tput sgr0)\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"\"

echo "\n$(tput setaf 2)zshify enabled! to reload, run -$(tput sgr0) exec zsh"

# Cleanup
[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile
