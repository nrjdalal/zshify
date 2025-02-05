MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true

  echo "Running brew update"
  brew update

  brew install -q fzf gh git jq mas nvm rsync zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
  echo "Brew formulae ensured."

  brew install -q --cask google-chrome visual-studio-code applite bruno fontbase iina numi qbittorrent spotify affinity-designer affinity-photo affinity-publisher
  echo "Brew casks ensured."

  echo "Running brew upgrade"
  brew upgrade

  echo "Running brew cleanup"
  brew cleanup --prune=1 -s
fi
