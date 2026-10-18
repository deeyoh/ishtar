local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.config.setup({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})

require("blink.cmp").setup({
  keymap = {
    preset = "default",
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  snippets = {
    preset = "luasnip",
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },

  signature = {
    enabled = true,
  },

  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
    },
  },
})
