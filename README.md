# Neovim config

This repo is a self-contained Neovim setup with a monolith runtime layout and a single top-level plugin tree.

It keeps `lazy.nvim` as the plugin manager, but the config logic itself lives in this repo. This was originally based off the distro, but its dependencies and logic as been extracted out. The `old` branch still relies on distro updates. But `main` will be a divergent and opinionated fork of the original distro. 
## Setup

### Requirements

Install:
- Neovim >= 0.11.2 (needs to be built with LuaJIT)
- Git >= 2.19.0 (for partial clones support)
- a Nerd Font(v3.0 or greater) (optional, but needed to display some icons)
- lazygit (optional)
- tree-sitter-cli and a C compiler for nvim-treesitter. See here
- curl for blink.cmp (completion engine)
- for fzf-lua (optional)
- fzf: fzf (v0.25.1 or greater)
- live grep: ripgrep
- find files: fd
- a terminal that support true color and undercurl:
- kitty (Linux & Macos)
- wezterm (Linux, Macos & Windows)
- alacritty (Linux, Macos & Windows)
- iterm2 (Macos)
- ghostty (Linux, Macos & Windows)

Recommended because this config uses them directly or benefits from them:

- `lazygit`
- Mason-managed tools you want for LSP / formatting / linting
- external language servers, formatters, and linters you personally use

### Install location

Put this repo at:

```bash
~/.config/nvim
```

### First boot

Start Neovim:

```bash
nvim
```

On first launch:

- `lazy.nvim` bootstraps itself if missing
- plugin specs are read
- plugins are installed using `lazy-lock.json`
- the runtime config is loaded from `lua/config/`
- your plugin overrides from `lua/plugins/` are applied after the core plugin specs

### Useful commands

- `:Lazy` to inspect plugins
- `:Lazy sync` to install or sync plugins
- `:checkhealth` to inspect environment issues

### Compare against upstream LazyVim

This repo includes:

```bash
scripts/lazyvim-diff.sh
```

Use it when you want to compare your flattened or moved files against the original LazyVim distro source.

It knows how to map files like:

- `lua/config/options.lua` -> `lua/lazyvim/config/options.lua`
- `lua/config/keymaps.lua` -> `lua/lazyvim/config/keymaps.lua`
- `lua/config/autocmds.lua` -> `lua/lazyvim/config/autocmds.lua`
- `lua/plugins/core/treesitter.lua` -> `lua/lazyvim/plugins/treesitter.lua`
- `lua/plugins/nvim-lspconfig.lua` -> `lua/lazyvim/plugins/lsp/init.lua`

Examples:

```bash
# Compare every tracked file against upstream LazyVim main
scripts/lazyvim-diff.sh

# Show only the local -> upstream mapping table
scripts/lazyvim-diff.sh --list

# Compare one specific file
scripts/lazyvim-diff.sh lua/plugins/core/treesitter.lua

# Use an already-installed local LazyVim checkout instead of fetching
LAZYVIM_UPSTREAM_DIR="$HOME/.local/share/nvim/lazy/LazyVim" scripts/lazyvim-diff.sh --list
```

This is useful when you want to inspect what changed from the distro and selectively port upstream updates into your own config.

## Structure

## Entry point

### `init.lua`

This only starts the main loader:

```lua
require("config.lazy")
```

### `lua/config/lazy.lua`

This file:

- bootstraps `lazy.nvim`
- imports `plugins.core`
- imports `plugins`

Load order matters:

1. `plugins.core` loads the internal base plugin specs
2. `plugins` loads your overrides after them

That is why your plugin config still has priority.

## Runtime config

### `lua/config/init.lua`

This is the runtime coordinator.

It is responsible for:

- setting up the shared compatibility helper object used across the config
- loading `options.lua`
- loading `autocmds.lua`
- loading `keymaps.lua`
- loading colorscheme setup and shared state
- handling extras from `lazyvim.json`

Even though the internal helper is still called `LazyVim` in code, it now points to code inside this repo.

### `lua/config/options.lua`

Single monolith file for options and related runtime globals.

This file now contains:

- baseline option defaults
- runtime globals
- your personal option overrides
- your SAFE mode logic

If the same option appears more than once in this file, the lower definition wins.

### `lua/config/keymaps.lua`

Single monolith file for keymaps.

This file now contains:

- baseline keymaps first
- the `LazyVimKeymapsDefaults` user event for compatibility
- your custom keymaps after that

That means your mappings override the earlier baseline mappings when they overlap.

### `lua/config/autocmds.lua`

Single monolith file for autocmds.

This file contains:

- baseline autocmds
- your custom autocmds after them

So this is the one place to adjust runtime automatic behavior.

## Plugin config

### `lua/plugins/`

This is now the only top-level plugin folder.

It contains two layers inside the same tree:

- `lua/plugins/core/` for the internal base plugin specs
- `lua/plugins/` root files for your custom overrides

The important part is that they now live inside one top-level plugin tree.

Use it when you want to:

- change plugin options
- add plugins
- disable plugins
- replace default plugin behavior

Because your root `plugins` import loads after `plugins.core`, your plugin changes win.

### `lua/config/util/`

Shared utility code used by the internal runtime.

This includes helper logic for:

- formatting
- LSP
- snippets
- root detection
- pickers
- extras
- lualine

Most users do not need to touch this often.

## State files

### `lazy-lock.json`

Locks plugin revisions so the same config can reproduce the same plugin versions on another machine.

### `lazyvim.json`

Despite the legacy name, this is just the local extras state file for this repo.

It stores enabled extras such as:

- `plugins.core.extras.lang.typescript`
- `plugins.core.extras.ui.dashboard-nvim`

## Priority rules

There are two main priority rules in this repo.

### Runtime priority

For options, keymaps, and autocmds:

- baseline logic appears first
- your custom logic appears later in the same file

Later lines win.

### Plugin priority

For plugin specs:

- `plugins.core` loads first
- `plugins` loads second

Later specs win.

## Where to edit things

### Change editor options

Edit:

```lua
lua/config/options.lua
```

Examples:

- line numbers
- conceal level
- scroll offsets
- runtime globals

### Change keymaps

Edit:

```lua
lua/config/keymaps.lua
```

Examples:

- leader mappings
- navigation keys
- terminal shortcuts
- buffer actions

### Change autocmds

Edit:

```lua
lua/config/autocmds.lua
```

Examples:

- autosave behavior
- reload behavior
- highlight hooks
- filetype-specific automation

### Change plugin behavior

Edit files in:

```lua
lua/plugins/
```

Examples:

- LSP changes
- completion changes
- UI changes
- adding or removing plugins

### Change the internal core plugin layer

Edit:

- `lua/plugins/core/`
- `lua/config/util/`

Do this when you want to change the pinned internal base itself, not just override it.

## Mental model

The easiest way to think about this config is:

- `lua/config/options.lua` = all runtime options
- `lua/config/keymaps.lua` = all runtime keymaps
- `lua/config/autocmds.lua` = all runtime autocmds
- `lua/plugins/core/` = internal base plugin layer
- `lua/plugins/` = your plugin overrides in the same top-level plugin tree

So the runtime side is monolithic, while the plugin side stays modular.

## Why it is built this way

This layout gives you:

- one obvious place for options
- one obvious place for keymaps
- one obvious place for autocmds
- no duplicate runtime files
- portable behavior across machines
- local overrides that stay authoritative

## Troubleshooting

### Neovim does not start

Check:

- Neovim version is `>= 0.11.2`
- `git` is installed
- the machine can bootstrap `lazy.nvim`

Then test:

```bash
nvim --headless '+qa'
```

### Plugins are missing or stale

Run:

```vim
:Lazy sync
```

### A change does not apply

Use the right layer:

- runtime behavior: `lua/config/options.lua`, `keymaps.lua`, `autocmds.lua`
- plugin behavior: `lua/plugins/`

If you change `lua/plugins/core/`, you are changing the internal base layer itself.
