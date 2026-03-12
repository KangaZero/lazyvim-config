-- Keymaps are automatically loaded on the VeryLazy event.
-- The pinned baseline lives in `lua/config/defaults/keymaps.lua`,
-- then this file applies personal overrides and additions.
-- Add any additional keymaps here
-- NOTE: wk is purely to add in icons for which-key, can't add the 'icon' property directly to keymap fn
local wk = require("which-key")
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
wk.add({
  { "<leader>h", icon = "󱣻 " },
})

-- Select all options
vim.keymap.set("n", "<leader>A", function() end, { desc = "Select all options" })
wk.add({
  { "<leader>A", icon = "󰁁 " },
})

vim.keymap.set({ "n", "v" }, "<leader>Ay", function()
  vim.cmd("normal! m'ggyG''")
  vim.cmd("delmarks a")
end, { desc = "Copy all to clipboard" })
wk.add({
  { "<leader>Ay", icon = "󰆏 " },
})

vim.keymap.set({ "n", "v" }, "<leader>Aa", function()
  vim.cmd("normal! ggVG")
end, { desc = "Select all" })
wk.add({
  { "<leader>Aa", icon = "󰒆 " },
})

vim.keymap.set("n", "<leader>Ad", function()
  vim.cmd("normal! ggdG")
end, { desc = "Delete all" })
wk.add({
  { "<leader>Ad", icon = "󰛌 " },
})
-- Blink completion options to show
-- TODO: make this actually work
vim.keymap.set({ "i", "n" }, "<shift>", function()
  require("blink.cmp").show()
end, { desc = "Show completion options" })

-- Mini map
vim.keymap.set("n", "<leader>um", function()
  require("mini.map").toggle()
end, { desc = "Toggle minimap" })
wk.add({
  { "<leader>um", icon = " " },
})

-- Get current file's directory
vim.keymap.set("n", "<leader>fd", function()
  local file_path = vim.fn.expand("%:p")
  local dir_path = vim.fn.fnamemodify(file_path, ":h")
  vim.fn.setreg("+", dir_path)
  print("Directory path copied to clipboard: " .. dir_path)
end, { desc = "Copy current file's directory to clipboard" })
wk.add({
  { "<leader>fd", icon = "󰓾 " },
})

-- Terminal in current buffer's directory
vim.keymap.set("n", "<leader>t", function()
  Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Terminal (current file dir)" })
wk.add({
  { "<leader>t", icon = " " },
})

--SPECIAL: For custom mode called 'SAFE'
--NOTE: The actual keymap implementation is in lua/config/options.lua
wk.add({
  { "<leader>m", icon = "󰦝 " },
})

-- Move lines up/down
-- INFO: alt + j/k does not work on Mac
vim.keymap.set({ "n", "v", "i" }, "<A-j>", "<cmd>m .+1<cr>", { desc = "Move line down" })
vim.keymap.set({ "n", "v", "i" }, "<A-Down>", "<cmd>m .+1<cr>", { desc = "Move line down" })
vim.keymap.set({ "n", "v", "i" }, "<A-k>", "<cmd>m .-2<cr>", { desc = "Move line up" })
vim.keymap.set({ "n", "v", "i" }, "<A-Up>", "<cmd>m .-2<cr>", { desc = "Move line up" })

--WARNING: Disabling minty as it is not keyboard friendly
-- require("minty.huefy").open()
-- vim.keymap.set("n", "<leader>P", function() end, { desc = "Open color picker" })
-- wk.add({
--   { "<leader>P", icon = " " },
-- })
--
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
