-- plugin/which-github.lua
-- This file is loaded automatically when Neovim starts (if in runtimepath)

vim.keymap.set({ "v", "n" }, "<leader>gr", function()
  require("which-github").get_repo_info()
end, { desc = "Show GitHub info for repo under cursor" })

-- TODO: fix this function
-- vim.keymap.set({ "v", "n" }, "<leader>gy", function()
--   require("which-github").yank_raw_json()
-- end, { desc = "Yank Github info as JSON" })
