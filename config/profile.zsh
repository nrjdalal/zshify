MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then

  echo && echo "==> System preferences..."
  restart_dock=false
  restart_finder=false
  [[ $(defaults read com.apple.AppleMultitouchTrackpad "Clicking") != 1 ]] && defaults write com.apple.AppleMultitouchTrackpad "Clicking" -bool "true"
  [[ $(defaults read com.apple.dock "autohide") != 1 ]] && defaults write com.apple.dock "autohide" -bool "true" && restart_dock=true
  [[ $(defaults read com.apple.dock "minimize-to-application") != 1 ]] && defaults write com.apple.dock "minimize-to-application" -bool "true" && restart_dock=true
  [[ $(defaults read com.apple.dock "orientation") != "left" ]] && defaults write com.apple.dock "orientation" -string "left" && restart_dock=true
  [[ $(defaults read com.apple.dock "show-recents") != 0 ]] && defaults write com.apple.dock "show-recents" -bool "false" && restart_dock=true
  [[ $(defaults read com.apple.dock "static-only") != 1 ]] && defaults write com.apple.dock "static-only" -bool "true" && restart_dock=true
  [[ $(defaults read com.apple.finder "CreateDesktop") != 0 ]] && defaults write com.apple.finder "CreateDesktop" -bool "false" && restart_finder=true
  [[ $(defaults read com.apple.finder "FXRemoveOldTrashItems") != 1 ]] && defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" && restart_finder=true
  [[ $(defaults read com.apple.finder "ShowPathbar") != 1 ]] && defaults write com.apple.finder "ShowPathbar" -bool "true" && restart_finder=true
  [[ $(defaults read com.apple.finder "ShowStatusBar") != 1 ]] && defaults write com.apple.finder "ShowStatusBar" -bool "true" && restart_finder=true
  [[ $(defaults read com.apple.HIToolbox "AppleFnUsageType") != 0 ]] && defaults write com.apple.HIToolbox "AppleFnUsageType" -int "0"
  [[ $(defaults read com.apple.WindowManager "EnableTiledWindowMargins") != 0 ]] && defaults write com.apple.WindowManager "EnableTiledWindowMargins" -bool "false"
  [[ $(defaults read NSGlobalDomain "NSAutomaticCapitalizationEnabled") != 0 ]] && defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool "false"
  [[ $(defaults read NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled") != 0 ]] && defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool "false"
  [[ $(defaults read NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled") != 0 ]] && defaults write NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled" -bool "false"
  [[ "$restart_dock" == true ]] && killall Dock
  [[ "$restart_finder" == true ]] && killall Finder

  echo && echo "==> Setting up git..."
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"

  echo && echo "==> Ensuring node..."
  source "/opt/homebrew/opt/nvm/nvm.sh"
  nvm install --lts
  corepack enable pnpm
  corepack enable yarn

  echo && echo "==> Setting up brew..."
  brew analytics off && brew update

  echo && echo "==> Ensuring brew formulae..."
  brew install -q fzf oven-sh/bun/bun gh git jq nvm rsync zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting

  echo && echo "==> Ensuring primary casks..."
  brew install -q --cask google-chrome visual-studio-code

  echo && echo "==> Ensuring secondary formulae..."
  brew install -q mas ollama tree

  echo && echo "==> Ensuring secondary casks..."
  brew install -q --cask bruno fontbase iina numi qbittorrent spotify raycast affinity-designer affinity-photo affinity-publisher

  echo && echo "==> Running brew upgrade..."
  brew upgrade

  echo && echo "==> Running brew cleanup..."
  brew cleanup --prune=1 -s

  if [[ ! -d ~/.config/karabiner/.git ]]; then
    echo && echo "==> Cloning karabiner configuration..."
    mkdir -p ~/.config/karabiner && cd ~/.config/karabiner && trash
    git clone https://github.com/nrjdalal/karabiner-human-config .
  fi

  echo && echo "==> Some manual steps if not already done...
---------------------------------------------

brew install --cask docker karabiner-elements

mas install 1502839586
mas install 1491071483

---------------------------------------------
"
fi
