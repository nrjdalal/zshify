#!/bin/zsh
mkdir -p ~/.zshify

# Clone the repository
git clone https://github.com/nrjdalal/zshify.git ~/.zshify
curl -s https://raw.githubusercontent.com/nrjdalal/pglaunch/main/bin/fx.sh | cat >~/.zshify/config/postgres.zsh

# Source the files
for config in prompt background fx alias plugins user postgres; do
  grep "source ~/.zshify/config/${config}.zsh" ~/.zshrc &>/dev/null || echo "source ~/.zshify/config/${config}.zsh" >>~/.zshrc
done

# Check if Homebrew is installed
if command -v brew &>/dev/null; then
  echo "\n$(tput setaf 2)brew is already installed!$(tput sgr0)"
else
  echo "\n$(tput setaf 1)brew not installed!$(tput sgr0) Install via:"
  echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
fi

echo "\n$(tput setaf 2)zshify enabled! to reload, run -$(tput sgr0) exec zsh"

# Cleanup
[ -f ~/.zshrc ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zshrc >~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
[ -f ~/.zprofile ] && grep -vxFf ~/.zshify/config/user.zsh ~/.zprofile >~/.zprofile.tmp && mv ~/.zprofile.tmp ~/.zprofile
