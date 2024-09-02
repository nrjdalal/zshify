# make and change to directory
cdx() {
  mkdir -p $1 && cd $1
}

alias mkcd='cdx'

# git add & git commit at once | git push
g() {
  command git add -A 2>/dev/null
  command git commit -m "$1" 2>/dev/null
  command git push
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
