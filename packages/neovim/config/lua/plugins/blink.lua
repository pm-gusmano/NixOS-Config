return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<CR>"] = { "fallback" }, -- always newline
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

        ["<Tab>"] = {
          "select_and_accept", -- accept if menu visible
          "fallback", -- otherwise indent
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
        },
        menu = {
          auto_show = true,
        },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
          show_on_insert_on_trigger_character = true,
          show_on_trigger_character = true,
        },
      },
    },
  },
}
