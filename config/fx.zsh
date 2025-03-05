# Create a directory and navigate into it
cdx() {
  mkdir -p $1 && cd $1
}

# Clone a GitHub repository
clone() {
  gh repo clone $@
}

# Add, commit, and push changes to git
g() {
  git add -A

  commit_diff=$(git diff HEAD --shortstat | sed -E 's/ insertions?[^)]*\)/+/g; s/ deletions?[^)]*\)/-/g' | xargs)
  commit_files=$(git diff HEAD --name-only | paste -sd ', ' -)

  commit_message="${*:-chore: small tweaks}"
  [[ "$commit_message" != *:* ]] && commit_message="chore: $commit_message"

  commit_with_diff="${commit_message} | ${commit_diff}"

  commit_message="$commit_with_diff
  
$commit_files"

  git commit -m "$commit_message" && git push || git push
}

# Initialize a git repository, add files, and create a GitHub repository
mkrepo() {
  git init && git add -A

  commit_msg="feat: init awesomeness"

  [[ "$#" -gt 0 && "${@: -1}" != "--public" && "${@: -1}" != "--private" ]] && commit_msg="$*"
  [[ "${@: -1}" == "--public" || "${@: -1}" == "--private" && "$#" -gt 1 ]] && commit_msg="${*:1:$#-1}"

  git commit -m "$commit_msg" 2>/dev/null

  repo_type="--private" && [[ "${@: -1}" == "--public" ]] && repo_type="--public"

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

# Delete all files and directories in the current directory
trash() {
  rm -rf * .*
}

# Remove commit history and create a new initial commit
only-commit() {
  CURRENT=$(git rev-parse --abbrev-ref origin/HEAD | cut -c8-)
  git checkout --orphan tempBranch
  git add -A
  if [[ "$#" == "0" ]]; then
    git commit -m "feat: init awesomeness"
  else
    git commit -m "$1"
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
