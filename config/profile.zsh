MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"
  git config --global init.defaultBranch "main"
  echo "Git configuration updated."

  brew install fzf gh git mas nvm rsync zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
  echo "Brew formulae ensured."

  brew install --cask google-chrome visual-studio-code applite bruno fontbase iina numi qbittorrent spotify affinity-designer affinity-photo affinity-publisher
  echo "Brew casks ensured."
fi
