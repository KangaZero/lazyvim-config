-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
vim.g.lazyvim_eslint_auto_format = true
vim.g.lazyvim_mini_snippets_in_completion = true
-- HACK: Disable mouse support to prevent accidental clicks and to make sure I do things the more efficient way
vim.opt.mouse = ""
vim.opt.scrolloff = 2 -- add 2 literal blank lines at the bottom and top
vim.opt.conceallevel = 0 -- show hidden lines in files like md
--SPECIAL: safe mode (read-only + navigation)
vim.g.safe = false

---@alias RhsCallback fun(): nil
---@alias Rhs string | RhsCallback

---@class KeymapEntry
---@field lhs string
---@field mode string

---@type KeymapEntry[]
local mode_keymaps = {}

---@param mode string | string[]
---@param lhs string
---@param rhs Rhs
---@param desc? string
local function set_mode_keymap(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = 0, silent = true, desc = desc })
  local modes = type(mode) == "table" and mode or { mode }
  for _, m in ipairs(modes) do
    table.insert(mode_keymaps, { lhs = lhs, mode = m })
  end
end

function exit_safe_mode()
  if not vim.g.safe then
    return
  end
  vim.g.safe = false
  vim.bo.modifiable = true
  for _, entry in ipairs(mode_keymaps) do
    pcall(vim.keymap.del, entry.mode, entry.lhs, { buffer = 0 })
  end
  mode_keymaps = {}
  vim.api.nvim_exec_autocmds("ModeChanged", {})
end

local function toggle_safe_mode()
  if vim.g.safe then
    exit_safe_mode()
    return
  end
  vim.bo.modifiable = false
  vim.g.safe = true
  -- stop any active macro recording before entering safe mode
  if vim.fn.reg_recording() ~= "" then
    vim.api.nvim_feedkeys("q", "n", false)
  end
  -- block all editing/deletion/macro/comment/paste keys
  local blocked = {
    "i",
    "I",
    "a",
    "A",
    "o",
    "O", -- insert
    "d",
    "D",
    "dd", -- delete
    "c",
    "C",
    "cc", -- change
    -- "s", -- INFO: By default it deletes the character under the cursor and enter insert mode. But I use a plugin called "Flash"
    -- "S", -- substitute
    "x",
    "X", -- delete char
    "r",
    "R", -- replace
    "gu",
    "gU",
    "gcc", --comment/uncomment
    "p",
    "P", -- paste (mutates buffer)
    "u",
    "<C-r>",
    "<C-a>",
    "<C-x>",
    "~", -- toggle case
    "=",
    "<",
    ">", -- indent
    "J", -- join lines
    "q", --macros
    "Q",
    "@",
    ".",
    "<leader>ca", -- code actions
    "<leader>cA", -- code actions
    "<leader>cr", -- rename actions
    "<leader>cR", -- rename actions
    "<leader>cf", -- format actions
    "<leader>cF", -- format actions
  }
  for _, lhs in ipairs(blocked) do
    set_mode_keymap("n", lhs, "<Nop>", "Safe: blocked")
  end

  -- visual modes are allowed (v, V, <C-v>) — no need to remap
  -- leader keymaps are allowed — they are not remapped here
  -- yank (y, Y, yy) is allowed — not blocked

  set_mode_keymap("n", "<Esc>", exit_safe_mode, "Safe: exit")
  vim.api.nvim_exec_autocmds("ModeChanged", {})
end

-- KEYMAPPING
vim.keymap.set("n", "<leader>m", toggle_safe_mode, { desc = "Toggle SAFE mode" })
vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
  callback = function()
    if vim.g.safe then
      exit_safe_mode()
    end
  end,
})
