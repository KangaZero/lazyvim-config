# Neovim config

This repository is a self-contained Neovim setup.

It keeps `lazy.nvim` as the plugin manager, but it does **not** depend on the upstream LazyVim distro at runtime. The pinned logic that used to live in a separate vendor folder has been flattened into this repo under `lua/config/`, so copying this directory to another machine keeps the same behavior.

## Goals

- Keep everything inside `~/.config/nvim`
- Keep plugin management with `lazy.nvim`
- Keep current behavior stable and portable
- Make local overrides win over the pinned baseline
- Keep the layout understandable without needing to inspect upstream projects

## Setup

### 1. Prerequisites

Install:

- Neovim `>= 0.11.2`
- `git`
- `ripgrep` (`rg`)

Recommended tools because parts of the config use them directly:

- `lazygit`
- language servers / formatters / linters you want to use
- any Mason-managed tools you expect this config to install automatically

### 2. Install the config

Clone or copy this repo to:

```bash
~/.config/nvim
```

### 3. First launch

Open Neovim:

```bash
nvim
```

On first start:

- `lazy.nvim` bootstraps itself if missing
- plugin specs are resolved
- plugins are installed from `lazy-lock.json`
- the pinned core config is loaded
- your local overrides are applied on top

### 4. Optional sync/update

Inside Neovim:

- run `:Lazy` to inspect plugins
- run `:Lazy sync` to install/update according to your config
- run `:checkhealth` if something looks off

## How this config is organized

### `init.lua`

The entrypoint. It only boots the main loader:

- `require("config.lazy")`

### `lua/config/lazy.lua`

This is the `lazy.nvim` bootstrap and import order.

It does two important things:

- bootstraps `lazy.nvim`
- loads `config.plugins` first and `plugins` second

That order is the main reason your own settings win:

1. `config.plugins` loads the pinned baseline plugin specs
2. `plugins` loads your personal plugin specs and overrides after that

Later specs merge into earlier ones, so your `lua/plugins/*.lua` changes take priority.

### `lua/config/init.lua`

This is the runtime coordinator for the flattened core logic.

It is responsible for:

- setting up the shared `LazyVim` compatibility global used throughout the config
- loading default runtime files
- loading your personal runtime files after the defaults
- setting colorscheme and shared config state
- handling extra-module bookkeeping from `lazyvim.json`

Even though the internal helper object is still called `LazyVim` in code, it is now local to this repo and backed by `lua/config/*`.

### `lua/config/defaults/`

This is the pinned baseline behavior that used to live in the separate vendored runtime.

Files here are loaded first:

- `options.lua`
- `keymaps.lua`
- `autocmds.lua`

Think of this folder as the baseline you want to keep stable across machines.

### `lua/config/options.lua`

Your personal option overrides.

Load order:

1. `lua/config/defaults/options.lua`
2. `lua/config/options.lua`

So if the same option is set in both places, **your** value wins.

### `lua/config/keymaps.lua`

Your personal keymaps and keymap overrides.

Load order:

1. `lua/config/defaults/keymaps.lua`
2. `lua/config/keymaps.lua`

So this is the right place to replace or add behavior without editing the pinned baseline.

### `lua/config/autocmds.lua`

Your personal autocmds and autocmd overrides.

Load order:

1. `lua/config/defaults/autocmds.lua`
2. `lua/config/autocmds.lua`

### `lua/config/plugins/`

Pinned core plugin specs and helper modules.

This folder contains the baseline plugin logic the config depends on:

- `init.lua`
- core plugin specs
- shared extras under `extras/`
- helper modules under `lsp/`

You usually do **not** need to edit this folder for routine customizations. It is the stable base layer.

### `lua/plugins/`

This is your main customization layer for plugins.

Use this folder when you want to:

- override plugin options
- add new plugins
- disable plugins
- replace default mappings or behavior

Because `lua/plugins/` loads after `lua/config/plugins/`, your plugin specs have priority.

### `lua/config/util/`

Shared utility logic used by the flattened core runtime.

Examples:

- formatting helpers
- snippet helpers
- root detection
- picker helpers
- extras handling
- lualine helpers

This is mostly internal infrastructure.

### `lazyvim.json`

Despite the filename, this is now just the local extras-state file for this repo.

It stores enabled extra modules, for example:

- `config.plugins.extras.lang.typescript`
- `config.plugins.extras.ui.dashboard-nvim`

The name is legacy, but the contents now point to the flattened `config.plugins.extras.*` namespace.

### `lazy-lock.json`

Plugin version lockfile.

This is what makes plugin versions reproducible across machines. If you want the same plugins everywhere, commit this file and keep it in sync with your intended plugin set.

## Load order and priority

This is the most important rule in the repo:

### Runtime files

For `options`, `keymaps`, and `autocmds`:

1. `lua/config/defaults/*.lua`
2. `lua/config/*.lua`

Your local runtime files win.

### Plugin specs

For plugins:

1. `config.plugins`
2. `plugins`

Your local plugin specs win.

## What to edit for common changes

### Change general editor options

Edit:

```lua
lua/config/options.lua
```

Examples:

- line numbers
- scroll offsets
- conceal level
- custom globals

### Add or override keymaps

Edit:

```lua
lua/config/keymaps.lua
```

Examples:

- custom leader mappings
- replacing a default mapping
- app-specific shortcuts

### Add or override autocmds

Edit:

```lua
lua/config/autocmds.lua
```

Examples:

- autosave
- file reload behavior
- custom highlighting hooks

### Change plugin behavior

Edit files in:

```lua
lua/plugins/
```

Examples:

- adjust `snacks.nvim`
- change LSP settings
- update completion behavior
- add or remove UI plugins

### Change the pinned baseline

Edit:

- `lua/config/defaults/*`
- `lua/config/plugins/*`
- `lua/config/util/*`

Do this when you want to change the shared base instead of just overriding it.

## Extras

The config still supports extras, but they now live under:

```lua
config.plugins.extras.*
```

The enabled extras are tracked in `lazyvim.json`.

So if you move this repo to another machine, the extras state moves with it too.

## Mental model

The easiest way to think about this repo is:

- `lua/config/defaults/` = pinned baseline runtime
- `lua/config/plugins/` = pinned baseline plugin specs
- `lua/config/util/` = pinned shared helpers
- `lua/config/*.lua` = your runtime overrides
- `lua/plugins/*.lua` = your plugin overrides

If you want to customize behavior without disturbing the base, edit the local override layers:

- `lua/config/options.lua`
- `lua/config/keymaps.lua`
- `lua/config/autocmds.lua`
- `lua/plugins/*`

## Why this layout exists

This setup was flattened on purpose so:

- you do not depend on upstream distro updates
- you can move the folder to another machine and keep behavior the same
- everything important is visible inside one config tree
- your custom config remains the final authority

## Quick troubleshooting

### Neovim will not start

Check:

- Neovim version is at least `0.11.2`
- `git` is installed
- `lazy.nvim` can be cloned on first boot

Then run:

```bash
nvim --headless '+qa'
```

### Plugins feel out of date or missing

Open Neovim and run:

```vim
:Lazy sync
```

### A change does not seem to apply

Remember the priority model:

- runtime overrides belong in `lua/config/*.lua`
- plugin overrides belong in `lua/plugins/*.lua`

If you edit the pinned baseline instead of the override layer, that is fine, but you are changing the shared base rather than just your local preference.
