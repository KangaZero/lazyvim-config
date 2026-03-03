return {
  "saghen/blink.cmp",
  opts = {
    scrollbar = false,
    completion = {
      keyword = {
        range = "full",
      },
      list = {
        max_items = 99,
      },
    },
    trigger = {
      show_on_backspace = true,
    },
    menu = {
      scrollbar = false,
    },
    keymap = {
      preset = "default",
      ["<S-Space>"] = { "show", "fallback" },
    },
  },
}
