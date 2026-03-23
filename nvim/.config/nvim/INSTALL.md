# Neovim Install Requirements

This config lives in `dotfiles/nvim/.config/nvim` and works best when a few tools are installed before first launch.

## Core requirements

- `neovim` `>= 0.11`
- `git`
- a Nerd Font for icons

## Recommended global tools

- `tree-sitter` CLI
- `ripgrep`
- `fd`
- `curl`

## Language and feature tools

Install these only if you use the related workflow.

### JavaScript / TypeScript / Web

- `node`
- `npm` or `pnpm`
- `prettier`
- `eslint_d`

### Python

- `python3`
- `ruff`
- `mypy`

### Go

- `go`
- optional but useful: `gopls`, `goimports`, `gofumpt`, `dlv`, `golangci-lint`

Note: this config now skips Go-specific setup when `go` is not installed.

### Shell

- `shfmt`
- `shellcheck`

### Docker

- `hadolint`

### YAML / JSON / SQL / Markdown

- `yamllint`
- `jsonlint`
- `sqlfluff`
- `sql-formatter`
- `markdownlint-cli2` or another `markdownlint` provider

### C / C++

- `clang-format`
- `cmake`

### Java

- `java`
- `google-java-format`

### Rust

- `rustup`
- `rustfmt`

## Optional apps used by keymaps

- `tmux` for `vim-tmux-navigator` and `vimux`
- `lazygit` for the floating Git terminal
- `htop` for the system monitor terminal shortcut
- `glow` for terminal markdown preview on `<leader>mg`
- `typora` for the markdown open-in-Typora keymaps

## Notes

- `markdown-preview.nvim` needs `node` to install and run.
- `lazyvim.plugins.extras.lang.go` stays enabled in `dotfiles/nvim/.config/nvim/lazyvim.json`, but the actual Go plugin file short-circuits when `go` is missing, so non-Go machines do not load the Go-specific setup.
- First launch may still install plugins and Mason packages in the background.
- If a language tool is missing, that language feature may be disabled or show a warning, but the rest of Neovim should still work.
