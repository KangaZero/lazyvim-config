return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = true, -- show hidden files (starting with .)
        hide_gitignored = true, -- show files ignored by .gitignore
      },
    },
  },
}
