vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { ".git", "flake.nix", "shell.nix" },
})

vim.lsp.enable("pyright")
