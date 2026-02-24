return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  event = "VimEnter",
  opts = function()
    local logo = [[
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣽⣯⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣟⣿⡾⣿⢾⣟⣾⣻⣾⣯⡿⣷⣿⢿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢟⣯⣿⣿⢷⣻⣯⣿⣟⡿⣟⣿⣽⣽⢾⣿⣿⣺⣿⡿⢿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢝⢋⢑⠈⠨⡺⣽⣿⢿⣷⣻⣽⣿⣯⡿⣟⡟⢽⢓⠕⣍⢵⢸⢬⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⢋⠫⣻⣿⣿⡀⠢⠅⠄⡑⡔⠌⢯⣟⣯⣿⡾⡯⣇⡯⣷⡿⡮⡪⣱⣱⣵⣷⣿⣷⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣟⣿⣞⣿⣾⣷⣅⠑⡄⠂⢟⣿⣿⣮⡈⠢⡔⠨⢊⢗⢝⣟⣗⡽⣻⣽⡟⡝⢏⢎⣺⣯⣿⣿⣿⣻⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡿⣾⣟⣷⣟⡿⣯⣿⣳⢿⣾⣿⣦⡘⡂⢅⠘⣿⣿⣷⣕⠵⡡⡳⢜⣯⢷⣟⢟⡚⢇⡕⡎⣇⣷⣞⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⢿⣻⣾⢿⣽⣷⡯⣿⣽⡿⣯⣿⣻⣟⣿⣳⢿⣽⣿⣬⢢⡵⣴⡛⣿⣽⣷⡠⢑⠱⢩⢓⢇⢣⢪⢱⣵⣟⣿⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣏⡚⣾⣿⡿⣯⣻⣽⣾⣿⢾⡽⣟⣿⣾⡽⣿⣻⠻⡽⣯⢾⡌⣾⣯⡷⣟⢼⣿⣿⣿⣿⢾⣴⣠⠡⡣⣵⣿⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢿⡌⢜⢺⣿⡿⣿⣽⣻⣾⣿⣮⠿⡛⡕⣟⣷⣻⣮⣻⣟⣿⡇⡝⣚⢻⢙⢼⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⢯⣟⣆⢕⢫⣿⣯⣿⣞⢏⢏⢎⢪⢑⠥⡹⡯⢟⢣⢪⢩⡢⡎⡎⡖⢕⢕⢽⣟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣻⢾⣆⠱⡹⢟⢝⢕⢥⢱⢱⣡⡡⢃⠕⡕⣕⢵⣱⣵⣵⣵⣷⣾⡾⣾⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣟⣿⣞⣎⢸⢸⢸⣸⣼⣺⣯⣿⣽⣿⣺⣾⣽⣯⣷⣿⣷⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣷⣿⣽⣷⢿⣟⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿[@KangaZero]⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
]]

    return {
      theme = "hyper",
      hide = { statusline = false, tabline = true, winbar = true },
      config = {
        header = vim.split(logo, "\n"),
        -- Shortcuts start
        shortcut = {
          { desc = " Purgatory Time", group = "DiagnosticHint", key = "f", action = "lua Snacks.picker.files()" },
          { desc = " New Hell", group = "DiagnosticInfo", key = "n", action = "ene | startinsert" },
          { desc = " Nightmares", group = "DiagnosticWarn", key = "r", action = "lua Snacks.picker.recent()" },
          {
            desc = " Config",
            group = "DiagnosticError",
            key = "c",
            action = "lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})",
          },
          { desc = " Lazy", group = "Number", key = "l", action = "Lazy" },
          {
            desc = " Abandon Hope",
            group = "Error",
            key = "q",
            action = function()
              local msgs = {
                "YOU THINK THERE IS AN EXIT?",
                "PURGATORY IS ETERNAL.",
                "ERROR: SOUL_BOUND_TO_VIM",
                "NICE TRY, MORTAL.",
              }
              math.randomseed(os.time())
              local msg = msgs[math.random(#msgs)]

              vim.notify(msg, vim.log.levels.ERROR, {
                title = "QUIT ATTEMPT DETECTED",
                timeout = 5000,
              })
            end,
          },
        },
        -- Shortcuts end (Correctly closed above)
        project = {
          enable = true,
          limit = 8,
          icon = " ",
          label = "Recent Purgatories",
          action = "lua Snacks.picker.files({cwd = %s})",
        },
        mru = { enable = true, limit = 10, label = "Past Sins", icon = "󱅠 " },
        packages = { enable = true },
        footer = function()
          local stats = require("lazy").stats()
          return {
            "",
            "" .. stats.loaded .. " PLUGINS INFECTED 󰯆 ",
            '"Y̶O̶U̶ ̶C̶A̶N̶ ̶N̶E̶V̶E̶R̶ ̶Q̶U̶I̶T̶.̶ ̶Y̶O̶U̶ ̶A̶R̶E̶ ̶H̶E̶R̶E̶ ̶F̶O̶R̶E̶V̶E̶R̶.̶"',
          }
        end,
      },
    }
  end,
}
