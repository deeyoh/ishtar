local capabilities = require("blink.cmp").get_lsp_capabilities()

vim.lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  capabilities = capabilities,
  root_markers = { "flake.nix", ".git" },

  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      }
    },
  },
})

vim.lsp.enable("nixd")
