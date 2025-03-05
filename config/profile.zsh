MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"

  echo "Running brew update!"
  brew update

  brew install -q fzf oven-sh/bun/bun gh git jq nvm rsync zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
  echo "Brew formulae ensured."

  brew install -q --cask google-chrome visual-studio-code
  echo "Primary casks ensured."

  brew install -q mas ollama tree
  echo "Secondary formulae ensured."

  brew install -q --cask bruno fontbase iina numi qbittorrent spotify raycast affinity-designer affinity-photo affinity-publisher
  echo "Secondary casks ensured."

  echo "Running brew upgrade"
  brew upgrade

  echo "Running brew cleanup"
  brew cleanup --prune=1 -s
fi
