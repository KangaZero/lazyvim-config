return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    pattern = [[\b(KEYWORDS)(:|\s)]],
    keywords = {
      SPECIAL = { icon = "特", color = "#3AE0BB" },
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}
