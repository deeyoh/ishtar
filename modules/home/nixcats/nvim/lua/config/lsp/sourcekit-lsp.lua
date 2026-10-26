local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("sourcekit-lsp", {
  cmd = { "sourcekit-lsp" },
  filetypes = { "swift" },
  root_markers = {
    ".git",
    "Package.swift",
  },

  capabilities = capabilities
})

vim.lsp.enable("sourcekit-lsp")
