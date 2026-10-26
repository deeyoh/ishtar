vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig" },
  root_markers = {
    "build.zig", ".git",
  },

  settings = {
    enable_build_on_save = true,
  },
})

vim.lsp.enable("zls")
