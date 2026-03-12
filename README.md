# 💤 Neovim config

This config keeps `lazy.nvim` as the plugin manager while vendoring the current LazyVim runtime directly in this repo under `lua/lazyvim/`.

Your local `lua/config/` and `lua/plugins/` files load after the vendored defaults so repo-local overrides always take priority.
