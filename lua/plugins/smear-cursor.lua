return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  -- Currently using kitty's cursor animation, so disable this plugin for now
  enabled = false,
  cond = vim.g.neovide == nil,
  opts = {
    hide_target_hack = true,
    cursor_color = "#A50B0D",
    cursor = { enable = false },
  },
  specs = {
    -- disable mini.animate cursor
    {
      "nvim-mini/mini.animate",
      optional = true,
      opts = {
        cursor = { enable = false },
      },
    },
  },
}
