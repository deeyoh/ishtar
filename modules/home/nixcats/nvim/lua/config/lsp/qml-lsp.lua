vim.lsp.config("qmlls", {
  cmd = { "qmlls" },
  filetypes = { "qml", "qmljs" },
  root_markers = { ".git", "flake.nix", "shell.nix" },
})

vim.lsp.enable("qmlls")
