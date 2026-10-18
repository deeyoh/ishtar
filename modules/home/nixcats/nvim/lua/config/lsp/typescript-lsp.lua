local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("ts_ls", {
  cmd = { "typescript-language-server", "--stdio" },

  filetypes = {
    "typescript",
    "typescriptreact",
  },

  root_markers = {
    "package.json",
    "tsconfig.json",
    "jsconfig.json",
    ".git",
  },
  capabilities = capabilities
})

vim.lsp.enable("ts_ls")
