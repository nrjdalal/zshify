# Zshify - A Minimalistic Touch To Your Prompt!

<img src="https://raw.githubusercontent.com/nrjdalal/zshify/master/zshify.png">

Zshify is a minimalistic, one command installation to customize the prompt of your Zshell or Zsh!

## Installation

```zsh
/bin/zsh -c "$(curl -fsSL https://rdt.li/zshify)"
```

Yeah that's it, no downloads, no hassle. A minimalistic installation for a minimalistic package.

> See advanced section to enrich your terminal experience with autosuggestions, history search and syntax highlighting.

## Why Zshify?

- Aren't you tired of your default Zsh prompt looking like this? Cluttered, ugly and slow?
- Don't you need some additional features / useful aliases and functions are added as default.

> dogefather@Dogeminers-Mac-mini ~ %

Appearing over and over again with the usual boring info? Like you really want to know your username over and over again.

Why not change it to it's minimal yet advanced version? And that too with colors!

### For Advanced Experience

```sh
# to enrich your terminal experience run this command after installing brew
brew install bat fzf zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
```

## What's Included

### Prompt

A minimal, informative prompt showing:

- Current directory (abbreviated)
- Git branch, ahead/behind counts, and stash count
- Responsive layout that adapts to terminal width

### Functions

| Command | Description |
| --- | --- |
| `cat` | syntax-highlighted output via `bat` (no pager, no line numbers) |
| `ls` | show hidden files with color and sorting when called without args |
| `cdx <dir>` | create a directory and cd into it |
| `clone <repo>` | clone a GitHub repository via `gh` |
| `switch [account]` | switch GitHub account via `gh auth` |
| `b <branch>` | switch to, track, or create a git branch |
| `g "message"` | add, commit with conventional prefix, and push |
| `gc "message"` | commit with auto-prefixed message |
| `ga` | stage all changes |
| `stash [name]` | stash changes or list stashes if clean |
| `pop [name]` | pop latest stash or pop by name |
| `unstash` | list and clear all stashes |
| `mkrepo [--public]` | init repo, commit, and create GitHub repository |
| `killport <port\|name>` | kill processes by port or name |
| `rename <name>` | rename current or existing directory |
| `rm` | clear directory contents with safeguards for home/desktop |
| `only-commit` | squash all history into a single commit |
| `reset [ref]` | hard reset and force push |
| `undo` | discard last commit and force push |
| `git-main` | migrate default branch from master to main |
| `next` | scaffold a Next.js project from template |

### Aliases

| Alias | Command |
| --- | --- |
| `c` | `cursor .` |
| `cr` | `cursor -r .` |
| `mkcd` | `cdx` |
| `trash` | `rm` |
| `add` | `ga` |
| `commit` | `gc` |
| `showdesk` / `hidedesk` | Toggle desktop icons |

### Git Enhancements

- `git` is wrapped to prevent accidental operations in `$HOME` or `~/Desktop`
- `git checkout -b <branch>` auto-switches if the branch already exists
- `npm` and `npx` are aliased to `bun` and `bunx` when bun is available (use `--real` to bypass)

### Background Tasks

Zshify runs a daily background task (via `background.zsh`) that:

- Executes the profile setup script (`profile.zsh`)
- Logs activity to `~/.logs/.brewlog`
- View logs with `brewlog`, clear with `brewlog clear`

### User Config

Add your personal configuration to `~/.zshify/config/user.zsh` — it's sourced last and won't be overwritten on updates.
