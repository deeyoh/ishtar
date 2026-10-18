vim.lsp.config("slint_lsp", {
  cmd = { "slint-lsp" },
  filetypes = { "slint" },
})

vim.lsp.enable("slint_lsp")
