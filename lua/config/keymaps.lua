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

vim.keymap.set("n", "<leader>h", "<cmd>Dashboard<cr>", { desc = "Home" })

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

-- Mini map
vim.keymap.set("n", "<leader>um", function()
  require("mini.map").toggle()
end, { desc = "Toggle minimap" })

-- Get current file's directory
vim.keymap.set("n", "<leader>fd", function()
  local file_path = vim.fn.expand("%:p")
  local dir_path = vim.fn.fnamemodify(file_path, ":h")
  vim.fn.setreg("+", dir_path)
  print("Directory path copied to clipboard: " .. dir_path)
end, { desc = "Copy current file's directory to clipboard" })

-- vim.keymap.set("n", "<C-Up>", function()
--   vim.cmd("resize +2")
-- end, { desc = "Resize window up" })
--
-- vim.keymap.set("n", "<C-Down>", function()
--   vim.cmd("resize -2")
-- end, { desc = "Resize window down" })
--
-- vim.keymap.set("n", "<C-Left>", function()
--   vim.cmd("vertical resize -2")
-- end, { desc = "Resize window left" })
--
-- vim.keymap.set("n", "<C-Right>", function()
--   vim.cmd("vertical resize +2")
-- end, { desc = "Resize window right" })
