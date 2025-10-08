return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
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
