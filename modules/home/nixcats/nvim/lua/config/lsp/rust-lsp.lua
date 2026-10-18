vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = {
    "Cargo.toml",
    "Cargo.lock",
    ".git",
  },

  settings = {
    ["rust-analyzer"] = {

      diagnostics = {
        enable = true
      },

      check = {
        command = "clippy"
      },
    }
  },
})

vim.lsp.enable("rust_analyzer")
