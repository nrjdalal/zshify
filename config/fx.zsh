# make and change to directory
cdx() {
  mkdir -p $1 && cd $1
}

# clone a github repository
clone() {
  gh repo clone $@
}

# git add & git commit at once | git push
g() {
  command git add -A && command git commit -m "$1" && command git push
}

# better listing
ls() {
  command ls -A --color | sort
}

# create github repository, pass nothing for private repo and pass --public for public repo
mkrepo() {
  command git init
  command git add -A 2>/dev/null
  command git commit -m "$(date)" 2>/dev/null

  if [[ "$1" == "--public" ]]; then
    command gh repo create $(basename $(pwd)) --description '' --source . --public --push
  else
    command gh repo create $(basename $(pwd)) --description '' --source . --private --push
  fi
}

# kill pid by port
close() {
  lsof -i :$1 | awk '{print $2}' | tail +2 | xargs kill -9
}

# rename current working dir or an existing folder
rename() {
  if [[ "$#" == "1" ]]; then
    command [ ! -d "../$1/" ] && rsync -a "$(pwd)/" "../$1" && rm -rf "$(pwd)/" && cd "../$1/"
    if [[ $? == 0 && "$TERM_PROGRAM" == "vscode" ]]; then
      code -r .
    fi
  elif [[ "$#" == "2" ]]; then
    command [ ! -d "$2/" ] && rsync -a "$1/" "$2" && rm -rf "$1/"
  else
    command echo "Usage:"
    command echo " rename new_dirname         ~ renames current working dir"
    command echo " rename dirname new_dirname ~ renames existing dir to new"
  fi
}

# remove all files and folders in current directory
trash() {
  command touch rm-a-temp .rm-a-temp
  command rm -rf * .*
}

# make the current commit the only commit in the repository
only-commit() {
  ORIGIN=$(git rev-parse --abbrev-ref origin/HEAD | cut -c8-)
  command git checkout --orphan newBranch
  command git add -A
  if [[ "$#" == "0" ]]; then
    command git commit -m "feat: initial commit"
  else
    command git commit -m "$1"
  fi
  command git branch -D $ORIGIN
  command git branch -m $ORIGIN
  command git push -f origin $ORIGIN
  command git gc --aggressive --prune=all
}

# remove the latest commit
undo() {
  command git reset --hard HEAD~1
  command git push -f
}

# better npm
if command -v bun &> /dev/null; then
  npm() {
    if [[ "$*" == *"--real"* ]]; then
      command npm "${@/--real/}"
    else
      bun "$@"
    fi
  }
  npx() {
    if [[ "$*" == *"--real"* ]]; then
      command npx "${@/--real/}"
    else
      bun x "$@"
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
