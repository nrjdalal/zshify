# make and change to directory
cdx() {
  mkdir -p $1 && cd $1
}

# clone a github repository
clone() {
  gh repo clone $@
}
g() { git add -A && git commit -m "$*" && git push || git push; }

# create github repository, pass nothing for private repo and pass --public for public repo
mkrepo() {
  git init
  git add -A 2>/dev/null
  git commit -m "feat: init awesomeness" 2>/dev/null

  if [[ "$1" == "--public" ]]; then
    gh repo create $(basename $(pwd)) --description '' --source . --public --push
  else
    gh repo create $(basename $(pwd)) --description '' --source . --private --push
  fi
}

# kill pid by port
close() {
  lsof -i :$1 | awk '{print $2}' | tail +2 | xargs kill -9
}

# rename current working dir or an existing folder
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
    echo " rename new_dirname         ~ renames current working dir"
    echo " rename dirname new_dirname ~ renames existing dir to new"
  fi
}

# remove all files and folders in current directory
trash() {
  touch rm-a-temp .rm-a-temp
  rm -rf * .*
}

# make the current commit the only commit in the repository
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

default-main() {
  git checkout master
  git checkout -b main
  git push -u origin main
  gh repo edit --default-branch main
  git push origin --delete master
}

# remove the latest commit
undo() {
  git reset --hard HEAD~1
  git push -f
}

# improving npm with bun
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
