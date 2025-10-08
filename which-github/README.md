# which_github

A lightweight Neovim plugin that fetches GitHub repository info for the text under cursor or a visual selection.

### Usage

1. Place your cursor over text like:
2. Press `<leader>gr`
3. See stars, forks, open issues, and last updated time.

### Installation (Lazy.nvim)

````lua
{
dir = "~/.config/nvim/which_github",
config = true,
}

---

## ✅ Final setup

In your **LazyVim plugin list** (like `~/.config/nvim/lua/plugins/custom.lua`), add:

```lua
{
  dir = "~/.config/nvim/which_github",
  config = true,
}

````
