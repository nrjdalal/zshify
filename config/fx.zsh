# make and change to directory
cdx() {
  mkdir -p $1 && cd $1
}

# better listing
ls() {
  command ls -A --color
  # tree --filesfirst -aCL 1 | sed -e 's/├── //g' -e 's/└── //g' | tail -n +2
}

# create github repository, pass --private to create private repository
mkrepo() {
  command git init
  command git add -A 2>/dev/null
  command git commit -m "$(date)" 2>/dev/null

  if [[ "$#" == "0" ]]; then
    command gh repo create $(basename $(pwd)) -d '' --push -s . --public
  else
    command gh repo create $(basename $(pwd)) -d '' --push -s . "$@"
  fi
}

# git add & git commit at once | git push
@git() {
  if [[ "$#" == "0" ]]; then
    command git add -A 2>/dev/null
    command git commit -m "$(date)" 2>/dev/null
    command git push
  elif [[ "$#" == "1" ]]; then
    command git add -A 2>/dev/null
    command git commit -m "$1" 2>/dev/null
    command git push
  fi
}

# manage npm packages using yarn (just add @ in front of npm)
@npm() {
  if [[ "$1" == "install" ]]; then
    command yarn add ${@:2}
  elif [[ "$1" == "uninstall" ]]; then
    command yarn remove ${@:2}
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
