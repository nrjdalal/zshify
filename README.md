# Zshify - A Minimalistic Touch To Your Prompt!

<img src="https://raw.githubusercontent.com/nrjdalal/zshify/master/zshify.png">

Zshify is a minimalistic, one command installation to customize the prompt of your Zshell or Zsh!

## Installation

Installation is done using the [`npx`](https://docs.npmjs.com/getting-started/installing-npm-packages-locally) command:

```zsh
npx zshify
```

Alternatively, you can install using `/bin/zsh -c "$(curl -fsSL https://rdt.li/zshify)"` command.

Yeah that's it, no downloads, no hassle. A minimalistic installation for a minimalistic package.

> See advanced section to to enrich your terminal experience with autosuggestions, history search and syntax highlighting.

## Why Zshify?

- Aren't you tired of your default Zsh prompt looking like this? Cluttered, ugly and slow?
- Don't you need some additional features / useful aliases and functions are added as default.

> dogefather@Dogeminers-Mac-mini ~ %

Appearing over and over again with the usual boring info? Like you really want to know your username over and over again.

Why not change it to it's minimal yet advanced version? And that too with colors!

### For Advanced Experience

```sh
# to enrich your terminal experience run this command after installing brew
brew install zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting fzf zoxide
```

### Alias

```sh
# open files and folders in vscode
alias mkcd="cdx"
alias c="code ."
alias cr="code -r ."
```

### Functions

```sh
# creates a directory recursively if it doesn't exists and switch to it
mkcd "newProject" || mkcd "newProject/subProject"

# clone any github repo
clone nrjdalal/zshify

# git add, commit and push (with message)
g "commit message"

# just enhanced version of ls with colors and sorting
ls

# create a github repo from command line (pass --public for private repo)
mkrepo || mkrepo --public

# close any application running on a given port
close 3000

# rename current directory to new name
rename "newName"

# trash all files and folders including hidden files
trash
```

### Postgres Launcher

```sh
pglaunch
```

<!-- 0 -->
