# Zshify - A Minimalistic Touch To Your Prompt!

<img src="zshify.png">

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

To enrich your terminal experience run this command after installing brew:

```zsh
brew install bat btop fd fzf ripgrep zoxide zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting
```

## What's Included

### Prompt

A minimal, informative prompt showing:

- Current directory (abbreviated)
- Git branch, ahead/behind counts, and stash count
- Responsive layout that adapts to terminal width

### Additional Tools

These are available when installed via the advanced brew command above:

| Command        | Description                                                          |
| -------------- | -------------------------------------------------------------------- |
| `btop`         | interactive system monitor for CPU, memory, disk, and network        |
| `cat <file>`   | syntax-highlighted output via `bat`                                  |
| `fd <pattern>` | fast file search, respects `.gitignore` (e.g. `fd -e tsx component`) |
| `fzf`          | interactive fuzzy finder (`Ctrl+T` to paste path, `Alt+C` to cd)     |
| `rg <pattern>` | fast text search in files via `ripgrep` (e.g. `rg "TODO" --type ts`) |
| `z <dir>`      | smart cd that learns your frequent directories via `zoxide`          |

### Functions

**File & directory**

| Command                 | Description                                                       |
| ----------------------- | ----------------------------------------------------------------- |
| `cdx <dir>`             | create a directory and cd into it                                 |
| `killport <port\|name>` | kill processes by port or name                                    |
| `ls`                    | show hidden files with color and sorting when called without args |
| `rename <name>`         | rename current or existing directory                              |
| `rm`                    | clear directory contents with safeguards for home/desktop         |

**Git workflow**

| Command        | Description                                    |
| -------------- | ---------------------------------------------- |
| `b <branch>`   | switch to, track, or create a git branch       |
| `g "message"`  | add, commit with conventional prefix, and push |
| `ga`           | stage all changes                              |
| `gc "message"` | commit with auto-prefixed message              |
| `pop [name]`   | pop latest stash or pop by name                |
| `stash [name]` | stash changes or list stashes if clean         |
| `unstash`      | list and clear all stashes                     |

**Git dangerous (with confirmation)**

| Command       | Description                                |
| ------------- | ------------------------------------------ |
| `git-main`    | migrate default branch from master to main |
| `only-commit` | squash all history into a single commit    |
| `reset [ref]` | hard reset and force push                  |
| `undo`        | discard last commit and force push         |

**GitHub & project setup**

| Command             | Description                                     |
| ------------------- | ----------------------------------------------- |
| `clone <repo>`      | clone a GitHub repository via `gh`              |
| `mkrepo [--public]` | init repo, commit, and create GitHub repository |
| `next`              | scaffold a Next.js project from template        |
| `switch [account]`  | switch GitHub account via `gh auth`             |

### Aliases

| Alias                   | Command              |
| ----------------------- | -------------------- |
| `add`                   | `ga`                 |
| `c`                     | `cursor .`           |
| `commit`                | `gc`                 |
| `cr`                    | `cursor -r .`        |
| `mkcd`                  | `cdx`                |
| `showdesk` / `hidedesk` | toggle desktop icons |
| `trash`                 | `rm`                 |

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
