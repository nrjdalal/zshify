#!/bin/zsh

DISABLE=0
MATCH_USERNAME="nrjdalal"

if [[ "$DISABLE" != "1" && "$USER" == "$MATCH_USERNAME" ]]; then
  mkdir -p ~/.logs

  echo && echo "==> System preferences..."
  if [[ ! -f ~/.logs/.brewdock.lock ]]; then
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    killall Dock
    touch ~/.logs/.brewdock.lock
  fi

  PREFERENCES_FILE=~/.zshify/config/preferences.json

  restart_dock=false
  restart_finder=false
  pref_changed=false
  typeset -A pref_domain_files
  typeset -A pref_domain_changed

  _normalize_pref_value() {
    local val="$1" type="$2"
    if [[ "$type" == "bool" ]]; then
      case "$val" in
        1|true|yes|TRUE|YES) echo "1" ;;
        0|false|no|FALSE|NO) echo "0" ;;
        *) echo "" ;;
      esac
    else
      echo "$val"
    fi
  }

  _json_pref_field() {
    local index="$1" field="$2" format="${3:-raw}"
    plutil -extract "preferences.$index.$field" "$format" -o - "$PREFERENCES_FILE" 2>/dev/null
  }

  _plist_pref_field() {
    local plist="$1" key="$2" format="${3:-raw}"
    plutil -extract "$key" "$format" -o - "$plist" 2>/dev/null
  }

  _plist_set_pref() {
    local plist="$1" key="$2" type="$3" value="$4" action="-replace"
    plutil -type "$key" "$plist" >/dev/null 2>&1 || action="-insert"

    case "$type" in
      bool) plutil "$action" "$key" -bool "$value" "$plist" ;;
      integer) plutil "$action" "$key" -integer "$value" "$plist" ;;
      float) plutil "$action" "$key" -float "$value" "$plist" ;;
      string) plutil "$action" "$key" -string "$value" "$plist" ;;
      date) plutil "$action" "$key" -date "$value" "$plist" ;;
      data) plutil "$action" "$key" -data "$value" "$plist" ;;
      json) plutil "$action" "$key" -json "$value" "$plist" ;;
      *)
        echo "==> Skipped unsupported preference type: $type for $key"
        return 1
        ;;
    esac
  }

  if [[ ! -f "$PREFERENCES_FILE" ]]; then
    echo "==> Preferences file not found: $PREFERENCES_FILE"
  elif ! plutil -type preferences "$PREFERENCES_FILE" >/dev/null 2>&1; then
    echo "==> Preferences file is invalid: $PREFERENCES_FILE"
  else
    pref_index=0
    while domain=$(_json_pref_field "$pref_index" domain raw); do
      key=$(_json_pref_field "$pref_index" key raw)
      type=$(_json_pref_field "$pref_index" type raw)
      extract_format="raw"
      [[ "$type" == "json" ]] && extract_format="json"
      value=$(_json_pref_field "$pref_index" value "$extract_format")

      if [[ -z "${pref_domain_files[$domain]}" ]]; then
        pref_plist=$(mktemp -t zshify-pref)
        if ! defaults export "$domain" "$pref_plist" >/dev/null 2>&1; then
          plutil -create xml1 "$pref_plist"
        fi
        pref_domain_files[$domain]="$pref_plist"
      fi

      pref_plist="${pref_domain_files[$domain]}"
      if plutil -type "$key" "$pref_plist" >/dev/null 2>&1; then
        current_value=$(_plist_pref_field "$pref_plist" "$key" "$extract_format")
      else
        current_value="<missing>"
      fi

      normalized_current=$(_normalize_pref_value "$current_value" "$type")
      normalized_desired=$(_normalize_pref_value "$value" "$type")

      if [[ "$current_value" == "<missing>" || "$normalized_current" != "$normalized_desired" ]]; then
        if _plist_set_pref "$pref_plist" "$key" "$type" "$value" >/dev/null; then
          updated_value=$(_plist_pref_field "$pref_plist" "$key" "$extract_format")
          echo "==> Updated: $domain $key from $current_value to $updated_value"
          pref_domain_changed[$domain]=1

          [[ "$domain" == "com.apple.dock" ]] && restart_dock=true
          [[ "$domain" == "com.apple.finder" ]] && restart_finder=true
          [[ "$domain" != "com.apple.dock" && "$domain" != "com.apple.finder" ]] && pref_changed=true
        fi
      fi

      ((pref_index++))
    done

    for domain pref_plist in ${(kv)pref_domain_files}; do
      [[ -n "${pref_domain_changed[$domain]}" ]] && defaults import "$domain" "$pref_plist"
      rm -f "$pref_plist"
    done
  fi

  echo && echo "==> Setting up brew..."
  export NONINTERACTIVE=1
  brew analytics off && brew update

  echo && echo "==> Ensuring brew formulae..."
  brew install -q bat btop fd fnm fzf gh git gnupg jq mas ollama ripgrep rsync tree zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting

  echo && echo "==> Ensuring node..."
  eval "$(fnm env)"
  fnm install --lts
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

mas install 1491071483

---------------------------------------------"

  echo && echo "==> Ensuring primary casks..."
  brew install -q --cask google-chrome cursor

  echo && echo "==> Ensuring secondary casks..."
  brew install -q --cask cleanshot fontbase iina jordanbaird-ice numi rocket screen-studio whatsapp affinity

  echo && echo "==> Running brew upgrade..."
  brew upgrade --formula

  echo && echo "==> Running cleanup..."
  rm -rf ~/.junk && brew cleanup --prune=1 -s

  echo && echo "==> Setting up git..."
  git config --global init.defaultBranch "main"
  git config --global push.autoSetupRemote true
  git config --global user.name "Neeraj Dalal"
  git config --global user.email "admin@nrjdalal.com"

  echo && echo "==> Setting up commit signing..."
  KEY_ID=$(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep '^sec' | head -n 1 | awk -F'/' '{print $2}' | awk '{print $1}')
  if [[ -z "$KEY_ID" ]]; then
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
    KEY_ID=$(gpg --list-secret-keys --keyid-format LONG | grep '^sec' | head -n 1 | awk -F'/' '{print $2}' | awk '{print $1}')
    GPG_PUBLIC_KEY=$(gpg --armor --export "$KEY_ID")
    echo "$GPG_PUBLIC_KEY" | gh gpg-key add -
  fi
  git config --global commit.gpgSign true
  git config --global gpg.program gpg
  git config --global user.signingkey "$KEY_ID"

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
