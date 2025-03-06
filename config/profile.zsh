MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then
  echo "==> System preferences..."
  [[ $(defaults read com.apple.dock "autohide") != 0 ]] && defaults write com.apple.dock "autohide" -bool false && killall Dock
  [[ $(defaults read com.apple.dock "minimize-to-application") != 1 ]] && defaults write com.apple.dock "minimize-to-application" -bool true && killall Dock
  [[ $(defaults read com.apple.dock "orientation") != "left" ]] && defaults write com.apple.dock "orientation" -string "left" && killall Dock
  [[ $(defaults read com.apple.dock "show-recents") != 0 ]] && defaults write com.apple.dock "show-recents" -bool false && killall Dock
  [[ $(defaults read com.apple.driver.AppleBluetoothMultitouch.trackpad "Clicking") != 1 ]] && defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "Clicking" -bool true
  [[ $(defaults read com.apple.finder "CreateDesktop") != 0 ]] && defaults write com.apple.finder "CreateDesktop" -bool false && killall Finder
  [[ $(defaults read com.apple.finder "ShowPathbar") != 1 ]] && defaults write com.apple.finder "ShowPathbar" -bool true && killall Finder
  [[ $(defaults read com.apple.finder "ShowStatusBar") != 1 ]] && defaults write com.apple.finder "ShowStatusBar" -bool true && killall Finder
  [[ $(defaults read com.apple.HIToolbox "AppleFnUsageType") != 0 ]] && defaults write com.apple.HIToolbox "AppleFnUsageType" -int 0
  [[ $(defaults read com.apple.WindowManager "EnableTiledWindowMargins") != 0 ]] && defaults write com.apple.WindowManager "EnableTiledWindowMargins" -bool false
  [[ $(defaults read NSGlobalDomain "NSAutomaticCapitalizationEnabled") != 0 ]] && defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool false
  [[ $(defaults read NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled") != 0 ]] && defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool false
  [[ $(defaults read NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled") != 0 ]] && defaults write NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled" -bool false

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

  echo "==> Ensuring node..."
  source "/opt/homebrew/opt/nvm/nvm.sh"
  nvm install --lts
  corepack enable pnpm
  corepack enable yarn

  if [[ ! -d ~/.config/karabiner/.git ]]; then
    echo "==> Cloning karabiner configuration..."
    mkdir -p ~/.config/karabiner && cd ~/.config/karabiner && trash
    git clone https://github.com/nrjdalal/karabiner-human-config .
  fi

  echo "\n==> Some manual steps if not already done...

---------------------------------------------

brew install --cask docker karabiner-elements

mas install 1502839586
mas install 1491071483

---------------------------------------------
"
fi
