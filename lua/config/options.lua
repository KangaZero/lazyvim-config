-- Monolith runtime options file.
-- Baseline options load first, then personal overrides load after them.
-- When the same setting is defined twice here, the later personal value wins.

-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LazyVim auto format
vim.g.autoformat = true

-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

-- LazyVim picker to use.
-- Can be one of: telescope, fzf
-- Leave it to "auto" to automatically use the picker
-- enabled with `:LazyExtras`
vim.g.lazyvim_picker = "auto"

-- LazyVim completion engine to use.
-- Can be one of: nvim-cmp, blink.cmp
-- Leave it to "auto" to automatically use the completion engine
-- enabled with `:LazyExtras`
vim.g.lazyvim_cmp = "auto"

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
vim.g.ai_cmp = true

-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

-- Optionally setup the terminal to use
-- This sets `vim.o.shell` and does some additional configuration for:
-- * pwsh
-- * powershell
-- LazyVim.terminal.setup("pwsh")

-- Set LSP servers to be ignored when used with `util.root.detectors.lsp`
-- for detecting the LSP root
vim.g.root_lsp_ignore = { "copilot" }

-- Hide deprecation warnings
vim.g.deprecation_warnings = false

-- Show the current document symbols location from Trouble in lualine
-- You can disable this for a buffer by setting `vim.b.trouble_lualine = false`
vim.g.trouble_lualine = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.formatexpr = "v:lua.LazyVim.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
-- HACK: Disable mouse support to prevent accidental clicks and to make sure I do things the more efficient way
opt.mouse = "" -- INFO: Replace with "a" to reenable the mouse
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 2 -- Add 2 lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.statuscolumn = [[%!v:lua.LazyVim.statuscolumn()]]
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Personal overrides -------------------------------------------------------

vim.g.lazyvim_eslint_auto_format = true
vim.g.lazyvim_mini_snippets_in_completion = true
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
