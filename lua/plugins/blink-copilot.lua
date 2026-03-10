return {
  "fang2hou/blink-copilot",
  ---@class Config
  ---@field max_completions integer Maximum number of completions to show
  ---@field max_attempts? integer Maximum number of attempts to fetch completions
  ---@field kind_name string|false The name of the kind
  ---@field kind_icon string|false The icon of the kind
  ---@field kind_hl string|false The highlight group of the kind
  ---@field debounce integer|false Debounce time in milliseconds
  ---@field auto_refresh? {backward?: boolean, forward?: boolean} Whether to auto-refresh completions
  opts = {
    max_completions = 2,
    max_attempts = 4,
    kind_name = "Copilot", ---@type string | false
    kind_icon = "󰚑 ", ---@type string | false
    kind_hl = false, ---@type string | false
    debounce = 200, ---@type integer | false
    auto_refresh = {
      backward = true,
      forward = true,
    },
  },
}
