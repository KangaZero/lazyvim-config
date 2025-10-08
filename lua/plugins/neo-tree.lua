return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false, -- show hidden files (starting with .)
        hide_gitignored = false, -- show files ignored by .gitignore
      },
    },
  },
}
