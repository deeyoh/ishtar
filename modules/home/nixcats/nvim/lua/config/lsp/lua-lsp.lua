local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },

  filetypes = { "lua" },

  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".git",
  },

  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "nixCats" },
      },
    },
  },
})

vim.lsp.enable("lua_ls")
