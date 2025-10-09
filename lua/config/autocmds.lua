-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = "*",
  callback = function()
    -- Save file by default
    vim.cmd("silent! w")
    -- Get full path of current file
    local file = vim.fn.expand("%:p")

    -- Check if it ends with ".lua"
    if file:match("%.lua$") then
      vim.cmd("source %")
      print("🔁 Reloaded " .. file)
    end
  end,
  nested = true,
})

vim.api.nvim_create_autocmd({ "CmdwinLeave", "CmdwinEnter" }, {
  pattern = { "*" },
  callback = function()
    print("Command window toggled")
  end,
  nested = true,
})
