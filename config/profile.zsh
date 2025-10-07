#!/bin/zsh

MATCH_USERNAME="nrjdalal"

if [[ "$USER" == "$MATCH_USERNAME" ]]; then

  echo && echo "==> System preferences..."
  if [[ ! -f ~/.logs/.brewdock.lock ]]; then
    defaults write com.apple.dock static-only -bool true && touch ~/.logs/.brewdock.lock
  else
    defaults write com.apple.dock static-only -bool false && killall Dock
  fi

  preferences=(
    "com.apple.dock autohide -bool 1"
    "com.apple.dock minimize-to-application -bool 1"
    "com.apple.dock orientation -string left"
    "com.apple.dock show-recents -bool 0"
    "com.apple.finder CreateDesktop -bool 0"
    "com.apple.finder FXRemoveOldTrashItems -bool 1"
    "com.apple.finder ShowPathbar -bool 1"
    "com.apple.finder ShowStatusBar -bool 1"

    "com.apple.AppleMultitouchTrackpad Clicking -bool 1"
    "com.apple.HIToolbox AppleFnUsageType -int 0"
    "com.apple.WindowManager EnableTiledWindowMargins -bool 0"
    "NSGlobalDomain NSAutomaticCapitalizationEnabled -bool 0"
    "NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool 0"
    "NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool 0"
  )

  restart_dock=false
  restart_finder=false
  pref_changed=false

  for pref in "${preferences[@]}"; do
    domain=$(echo "$pref" | cut -d' ' -f1)
    key=$(echo "$pref" | cut -d' ' -f2)
    type=$(echo "$pref" | cut -d' ' -f3)
    value=$(echo "$pref" | cut -d' ' -f4)
    current_value=$(defaults read "$domain" "$key" 2>/dev/null)

    if [[ "$current_value" != "$value" ]]; then
      command="defaults write $domain $key"
      [[ "$type" == "bool" ]] && command="$command -bool"
      [[ "$type" == "int" ]] && command="$command -int"
      [[ "$type" == "string" ]] && command="$command -string"
      eval "$command $value"
      updated_value=$(defaults read "$domain" "$key")
      echo "==> Updated: $domain $key from $current_value to $updated_value"

      [[ "$domain" == "com.apple.dock" ]] && restart_dock=true
      [[ "$domain" == "com.apple.finder" ]] && restart_finder=true
      [[ "$domain" != "com.apple.dock" && "$domain" != "com.apple.finder" ]] && pref_changed=true
    fi
  done

  echo && echo "==> Setting up brew..."
  export NONINTERACTIVE=1
  brew analytics off && brew update

  echo && echo "==> Ensuring brew formulae..."
  brew install -q --force fzf oven-sh/bun/bun gh git gnupg jq mas ni nvm ollama python@3.9 rsync tree zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting

  echo && echo "==> Ensuring node..."
  source "/opt/homebrew/opt/nvm/nvm.sh"
  nvm install --lts
  corepack enable pnpm
  corepack enable yarn

  if [[ ! -d ~/.config/karabiner/.git ]]; then
    echo && echo "==> Cloning karabiner configuration..."
    mkdir -p ~/.config/karabiner && cd ~/.config/karabiner && trash
    git clone https://github.com/nrjdalal/karabiner-human-config .
  fi

  echo && echo "==> Some manual steps if not already done...
---------------------------------------------

gh auth login --scopes "repo, read:org, workflow, write:gpg_key"

# https://gumroad.com/library for Supercharge
# https://usgraphics.com/accounts for Berkeley Mono

brew install --cask --force docker karabiner-elements

mas install 1502839586
mas install 1491071483

---------------------------------------------"

  echo && echo "==> Ensuring primary casks..."
  brew install -q --cask --force google-chrome visual-studio-code

  echo && echo "==> Ensuring secondary casks..."
  brew install -q --cask --force bruno fontbase iina jordanbaird-ice numi pearcleaner qbittorrent raycast rocket whatsapp affinity-designer affinity-photo affinity-publisher

  echo && echo "==> Running brew upgrade..."
  brew upgrade

  echo && echo "==> Running cleanup..."
  rm -rf ~/.junk && brew cleanup --prune=1 -s

  echo && echo "==> Setting up git..."
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"

  echo && echo "==> Setting up commit signing..."
  gpg --batch --generate-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Neeraj Dalal
Name-Email: admin@nrjdalal.com
Expire-Date: 0
EOF
  git config --global commit.gpgSign true
  git config --global gpg.program gpg
  KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep '^sec' | head -n 1 | awk -F'/' '{print $2}' | awk '{print $1}')
  git config --global user.signingkey $KEY_ID
  GPG_PUBLIC_KEY=$(gpg --armor --export $KEY_ID)
  echo "$GPG_PUBLIC_KEY" | gh gpg-key add -

  echo && echo "==> Finalizing..."
  [[ "$restart_dock" == true ]] && killall Dock
  [[ "$restart_finder" == true ]] && killall Finder
  if [[ "$pref_changed" == true ]]; then
    osascript <<EOF
set dialogTitle to "System Settings"
set dialogMessage to "Preferences updated. Restart to apply changes."
set userChoice to button returned of (display dialog dialogMessage with title dialogTitle buttons {"Restart Now", "Later"} default button "Later")
if userChoice is "Restart Now" then
  do shell script "sudo shutdown -r now" with administrator privileges
end if
EOF
  fi
fi

echo && echo "==> Done!"
