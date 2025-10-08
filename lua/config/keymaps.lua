-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
function KeymapSet(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

vim.keymap.set("n", "<leader>gg", function()
  vim.cmd("split | terminal lazygit")
end, { desc = "Open Lazygit" })

vim.keymap.set("n", "<leader>h", Snacks.dashboard.open, { desc = "Home" })

-- Select all options
vim.keymap.set("n", "<leader>A", function() end, { desc = "Select all options" })

vim.keymap.set({ "n", "v" }, "<leader>Ay", function()
  vim.cmd("normal! ggVGy")
end, { desc = "Copy all to clipboard" })

vim.keymap.set({ "n", "v" }, "<leader>Aa", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })

vim.keymap.set("n", "<leader>Ad", function()
  vim.cmd("normal! ggVGd")
end, { desc = "Delete all" })

-- Resize window with navigation keymaps
vim.keymap.set("n", "<C-Up>", function()
  vim.cmd("resize +2")
end, { desc = "Resize window up" })

vim.keymap.set("n", "<C-Down>", function()
  vim.cmd("resize -2")
end, { desc = "Resize window down" })

vim.keymap.set("n", "<C-Left>", function()
  vim.cmd("vertical resize -2")
end, { desc = "Resize window left" })

vim.keymap.set("n", "<C-Right>", function()
  vim.cmd("vertical resize +2")
end, { desc = "Resize window right" })
