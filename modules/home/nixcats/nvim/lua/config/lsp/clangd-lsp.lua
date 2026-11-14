vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index" },
  filetypes = { "c", "cpp" },
  root_markers = { "flake.nix", ".git" }
})

vim.lsp.enable("clangd")
