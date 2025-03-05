MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then
  echo "==> Setting up git..."
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"

  brew analytics off && brew update

  echo "==> Ensuring brew formulae..."
  brew install -q fzf oven-sh/bun/bun gh git jq nvm rsync zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting

  echo "==> Ensuring primary casks..."
  brew install -q --cask google-chrome visual-studio-code

  echo "==> Ensuring secondary formulae..."
  brew install -q mas ollama tree

  echo "==> Ensuring secondary casks..."
  brew install -q --cask bruno fontbase iina numi qbittorrent spotify raycast affinity-designer affinity-photo affinity-publisher

  echo "==> Running brew upgrade..."
  brew upgrade

  echo "==> Running brew cleanup..."
  brew cleanup --prune=1 -s

  if [[ ! -d ~/.config/karabiner/.git ]]; then
    echo "==> Cloning karabiner configuration..."
    mkdir -p ~/.config/karabiner && cd ~/.config/karabiner && trash
    git clone https://github.com/nrjdalal/karabiner-human-config .
  fi

  echo "==> Some manual steps if not already done...

---------------------------------------------

nvm install --lts
corepack enable pnpm
corepack enable yarn

brew install --cask docker karabiner-elements

mas install 1502839586
mas install 1491071483

---------------------------------------------
"
fi
