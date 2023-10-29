# Zshify - A Minimalistic Touch To Your Prompt!

<img src="https://raw.githubusercontent.com/nrjdalal/zshify/master/zshify.png">

Zshify is a minimalistic, one command installation to customize the prompt of your Zshell or Zsh!

## Installation

Installation is done using the [`npx`](https://docs.npmjs.com/getting-started/installing-npm-packages-locally) command:

```zsh
npx zshify
```

Alternatively, you can install using `bunx`.

Yeah that's it, no downloads, no hassle. A minimalistic installation for the minimalistic package.

> See advanced section to to enrich your terminal experience with autosuggestions, history search and syntax highlighting .

## Why Zshify?

Aren't you tired of your default Zsh prompt looking like this? Cluttered, ugly and slow?

> dogefather@Dogeminers-Mac-mini ~ %

Appearing over and over again with the usual boring info? Like you really want to know your username over and over again.

Why not change it to it's minimal version? And that too with colors!

## Some addition feature / useful aliases and functions are added as default

### Adanced

```sh
# to enrich your terminal experience run this command after installing brew
brew install zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
```

### Alias

```sh
# open files and folders in vscode
alias c="code ."
alias cr="code -r ."

# open files and folders in finder
alias o="open ."

# hide or show files and folders in desktop
alias hide="defaults write com.apple.finder CreateDesktop false && killall Finder"
alias show="defaults write com.apple.finder CreateDesktop true && killall Finder"
```

### Functions

```sh
# close any application running on a port
close 3000

# git add, commit and push (with message)
g "commit message"

# just enhanced version of ls with colors and sorting
ls

# creates a directory recursively if it doesn't exists and switch to it
mkcd "newProject" || mkcd "newProject/subProject"

# create a github repo from command line (pass --public for private repo)
mkrepo || mkrepo --public

# rename current directory to new name
rename "newName"
```
