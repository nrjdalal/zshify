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
brew install zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting fzf zoxide
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
| `ls` | Enhanced ls with hidden files, color, and sorting (no args). Passes through to default ls with flags. |
| `cdx <dir>` | Create a directory and cd into it |
| `clone <repo>` | Clone a GitHub repo via `gh` |
| `switch [account]` | Switch GitHub account with `gh auth` |
| `b <branch>` | Switch to, track, or create a git branch |
| `g "message"` | Add, commit (with conventional prefix), and push |
| `gc "message"` | Commit with auto-prefixed message |
| `ga` | Stage all changes |
| `stash [name]` | Push stash if changes exist, list stashes if clean. With a name, pushes a named stash. |
| `pop [name]` | Pop latest stash, or pop by name |
| `unstash` | List and clear all stashes (with confirmation) |
| `mkrepo [--public]` | Init repo, commit, and create GitHub repo |
| `killport <port\|name>` | Kill processes on a port or by name |
| `rename <name>` | Rename current directory |
| `rm` | Enhanced rm that clears directory contents, with safeguards for home/desktop |
| `only-commit` | Squash all history into a single commit (with confirmation) |
| `reset [ref]` | Hard reset and force push (with confirmation) |
| `undo` | Discard last commit and force push (with confirmation) |
| `git-main` | Migrate default branch from master to main |
| `next` | Scaffold a Next.js project from template |

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
