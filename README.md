# Zshify - A Minimalistic Touch To Your Prompt!

<img src="https://raw.githubusercontent.com/nrjdalal/zshify/master/zshify.png" width="480">

Zshify is a minimalistic, one command installation to customize the prompt of your Zshell or Zsh!

## Installation

Installation is done using the [`npx` command](https://docs.npmjs.com/getting-started/installing-npm-packages-locally):

```zsh
npx zshify
```

Yeah that's it, no downloads, no hassle. A minimalistic installation for the minimalistic package.

## Why Zshify?

Aren't you tired of your default Zsh prompt looking like this? Cluttered, ugly and slow?

> dogefather@Dogeminers-Mac-mini ~ %

Appearing over and over again with the usual boring info? Like you really want to know your username over and over again.

Why not change it to it's minimal version? And that too with colors!

## Alias

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

## Functions

- cdx: create a directory recursively if it doesn't exists and switch to it
- g: git add, commit and push (with message)
- ls: just enhanced version of ls with colors and sorting
