return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
    },
  },
  -- Configure LazyVim to load gruvbox {
  "LazyVim/LazyVim",
  opts = {
    colorscheme = "tokyonight",
  },
}
