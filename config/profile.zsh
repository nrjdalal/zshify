#!/bin/zsh

MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then

  echo && echo "==> System preferences..."
  preferences=(
    "com.apple.AppleMultitouchTrackpad Clicking -bool 1"
    "com.apple.dock autohide -bool 1"
    "com.apple.dock minimize-to-application -bool 1"
    "com.apple.dock orientation -string left"
    "com.apple.dock show-recents -bool 0"
    "com.apple.dock static-only -bool 1"
    "com.apple.finder CreateDesktop -bool 0"
    "com.apple.finder FXRemoveOldTrashItems -bool 1"
    "com.apple.finder ShowPathbar -bool 1"
    "com.apple.finder ShowStatusBar -bool 1"
    "com.apple.HIToolbox AppleFnUsageType -int 0"
    "com.apple.WindowManager EnableTiledWindowMargins -bool 0"
    "NSGlobalDomain NSAutomaticCapitalizationEnabled -bool 0"
    "NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool 0"
    "NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool 0"
  )

  restart_dock=false
  restart_finder=false

  for pref in "${preferences[@]}"; do
    domain=$(echo "$pref" | cut -d' ' -f1)
    key_name=$(echo "$pref" | cut -d' ' -f2)
    type=$(echo "$pref" | cut -d' ' -f3)
    value=$(echo "$pref" | cut -d' ' -f4)
    current_value=$(defaults read "$domain" "$key_name" 2>/dev/null)

    if [[ "$current_value" != "$value" ]]; then
      updated_value=$(defaults write "$domain" "$key_name" $type "$value" && defaults read "$domain" "$key_name")
      echo "==> Updated $domain $key_name from $current_value to $updated_value"
    fi

    [[ "$domain" == "com.apple.dock" ]] && restart_dock=true
    [[ "$domain" == "com.apple.finder" ]] && restart_finder=true
  done

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
