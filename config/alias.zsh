alias c="code ."
alias cr="code -r ."
alias ls="ls -A --color | sort"
alias mkcd='cdx'
alias trash='rm'

# system
alias showdesk="defaults write com.apple.finder CreateDesktop true; killall Finder;"
alias hidedesk="defaults write com.apple.finder CreateDesktop false; killall Finder;"

# npm
alias ai="bunx dalal@latest ollama"
alias nanoid="bunx nanoid@latest --alphabet QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm1234567890 --size 24"
alias pick="bunx gitpick@latest"
alias ts="bunx gitpick@latest nrjdalal/the-typescript-starter ."
alias ui="bunx shadcn@latest add -o https://dub.sh/ui.json && bunx prettier --write --ignore-unknown *"

next() {
  bunx gitpick@latest nrjdalal/awesome-templates/tree/main/next.js-apps/next.js-pro .
  bun i
  bunx fx '({
    ...this,
    name: require("path").basename(process.cwd())
  })' package.json >package.tmp.json && mv package.tmp.json package.json
  if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
    git init
    git add .
    git commit -S -m "feat: init awesomeness"
  fi
}
