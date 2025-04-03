# Create a directory and navigate into it
cdx() {
  mkdir -p $1 && cd $1
}

# Clone a GitHub repository
clone() {
  gh repo clone $@
}

# Protect directories from git commands
git() {
  [[ "$PWD" == "$HOME" || "$PWD" == "$HOME/Desktop" ]] || command git $@
}

# Switch to a branch or create a new branch
b() {
  if [[ -z "$1" ]]; then
    echo "Usage: b <branch-name>"
    return 1
  fi

  git checkout $1 2>/dev/null || git checkout -b $1
}

# Add, commit, and push changes to git
g() {
  git add -A

  changed_files=$(git diff --numstat HEAD | awk '{print $1 + $2, $3}' | sort -nr | cut -d' ' -f2-)
  files_list=$(echo "$changed_files" | awk -F'/' '{print $NF}' | tr '\n' ' ')

  other_files=$(echo "$changed_files" | grep -vE '^(package\.json|bun\.lock|package-lock\.json|pnpm-lock\.yaml|yarn\.lock)$') && [ -n "$other_files" ] && changed_files="$other_files"
  if echo "$changed_files" | grep -qE '^\.github/workflows'; then
    commit_message="${*:-$([ -z "$(echo "$changed_files" | grep -vE '^\.github/workflows')" ] && echo "ci: tweaks" || echo "chore: tweaks")}"
  elif echo "$changed_files" | grep -qE '\.md$'; then
    commit_message="${*:-$([ -z "$(echo "$changed_files" | grep -vE '\.md$')" ] && echo "docs: tweaks" || echo "chore: tweaks")}"
  else
    commit_message="${*:-chore: tweaks}"
  fi

  [[ "$commit_message" != *:* ]] && commit_message="chore: $commit_message"

  if [[ $(echo "$commit_message > $files_list" | wc -c) -gt 100 ]]; then
    commit_message=$(echo "$commit_message > $files_list" | cut -c 1-97)...
  else
    commit_message=$(echo "$commit_message > $files_list")
  fi

  commit_message="$commit_message
  
$changed_files"

  git commit -S -m "$commit_message" && git push || git push
}

# Initialize a git repository, add files, and create a GitHub repository
mkrepo() {
  git init && git add -A
  repo_type="--private"
  commit_msg="${*:-feat: init awesomeness}"
  [[ "$*" == *"--public"* ]] && repo_type="--public"
  [[ "$*" == *"--private"* ]] && repo_type="--private"
  commit_msg=$(echo "$commit_msg" | sed 's/--public//g' | sed 's/--private//g' | xargs)
  [[ -z "$commit_msg" ]] && commit_msg="feat: init awesomeness"
  git commit -S -m "$commit_msg" 2>/dev/null
  gh repo create $(basename $(pwd)) --description '' --source . $repo_type --push
}

# Kill processes using a specific port
killport() {
  if [[ -z "$1" ]]; then
    echo "Usage: close_port <port>"
    return 1
  fi

  pids=$(lsof -ti :$1)

  if [[ -z "$pids" ]]; then
    echo "No processes found using port $1"
    return 0
  fi

  echo "$pids" | xargs kill -9
  echo "Closed processes using port $1"
}

# Rename current working directory or existing directory
rename() {
  if [[ "$#" == "1" ]]; then
    [ ! -d "../$1/" ] && rsync -a "$(pwd)/" "../$1" && rm -rf "$(pwd)/" && cd "../$1/"
    if [[ $? == 0 && "$TERM_PROGRAM" == "vscode" ]]; then
      code -r .
    fi
  elif [[ "$#" == "2" ]]; then
    [ ! -d "$2/" ] && rsync -a "$1/" "$2" && rm -rf "$1/"
  else
    echo "Usage:"
    echo " rename_dir new_dirname         ~ renames current working dir"
    echo " rename_dir dirname new_dirname ~ renames existing dir to new"
  fi
}

# Better rm command
rm() {
  declare -a secure_dirs=("$HOME" "$HOME/Desktop")

  local confirm=false
  local args=()
  for arg in "$@"; do
    if [[ "$arg" == "--confirm" ]]; then
      confirm=true
    else
      args+=("$arg")
    fi
  done

  if ! $confirm; then
    local current_dir=$(pwd | tr '[:upper:]' '[:lower:]')
    for dir in "${secure_dirs[@]}"; do
      if [[ "$current_dir" == "$(echo "$dir" | tr '[:upper:]' '[:lower:]')" ]]; then
        echo -e "\nYou are in a secured directory. Use --confirm to proceed."
        return 1
      fi
    done
  fi

  if [[ "${#args[@]}" -eq 0 ]]; then
    local dir_count=$(find . -maxdepth 1 -type d ! -name "." ! -name ".." | wc -l | xargs)
    local file_count=$(find . -maxdepth 1 -type f ! -name "." ! -name ".." ! -name ".*" | wc -l | xargs)
    local hidden_file_count=$(find . -maxdepth 1 -type f -name ".*" ! -name "." ! -name ".." | wc -l | xargs)
    file_count=$((file_count + hidden_file_count))
    find . -maxdepth 1 ! -name "." ! -name ".." -exec rm -rf {} +
    echo -e "\n$dir_count directories, $file_count files removed"
  else
    command rm "${args[@]}"
  fi
}

# Remove commit history and create a new initial commit
only-commit() {
  CURRENT=$(git rev-parse --abbrev-ref origin/HEAD | cut -c8-)
  git checkout --orphan tempBranch
  git add -A
  if [[ "$#" == "0" ]]; then
    git commit -S -m "feat: init awesomeness"
  else
    git commit -S -m "$1"
  fi
  git branch -D $CURRENT
  git branch -m $CURRENT
  git push -f origin $CURRENT
  git gc --aggressive --prune=all
}

# Change the default branch from master to main
git-main() {
  git checkout master
  git checkout -b main
  git push -u origin main
  gh repo edit --default-branch main
  git push origin --delete master
}

# Reset the git repository to a specific commit
reset() {
  git reset --hard $1
  git push -f
}

# Undo the last git commit
undo() {
  git reset --hard HEAD~1
  git push -f
}

# Use bun instead of npm, if --real is passed, use the real npm
if command -v bun &>/dev/null; then
  npm() {
    if [[ "$*" == *"--real"* ]] || [[ -n "$USE_REAL_NPM" ]]; then
      export USE_REAL_NPM=1
      trap 'unset USE_REAL_NPM' EXIT
      command npm $(echo "${@/--real/}" | xargs)
    else
      bun "$@"
    fi
  }
  npx() {
    if [[ "$*" == *"--real"* ]] || [[ -n "$USE_REAL_NPX" ]]; then
      export USE_REAL_NPX=1
      trap 'unset USE_REAL_NPX' EXIT
      command npx $(echo "${@/--real/}" | xargs)
    else
      bunx "$@"
    fi
  }
else
  npm() {
    command npm "$@"
  }
  npx() {
    command npx "$@"
  }
fi
