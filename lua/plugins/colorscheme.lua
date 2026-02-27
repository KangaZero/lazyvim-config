return {
  {
    "neko-night/nvim",
    name = "nekonight",
    config = function()
      -- 1. Setup the theme with transparency enabled
      require("nekonight").setup({
        transparent = true, -- This is the standard toggle for NekoNight
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
      })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nekonight-deep-ocean",
      transparent = true,
    },
  },
}
