return {
  "brenoprata10/nvim-highlight-colors",
  enabled = true,
  config = function()
    require("nvim-highlight-colors").setup({
      ---@usage 'background'|'foreground'|'virtual'
      render = "background",
      ---@usage 'rgb'|'hex'|'hsl'
      enable_named_colors = true,
      enable_tailwind = true,
      exclude_filetypes = { "lazy", "mason", "help", "neogitstatus" },
    })
  end,
}
