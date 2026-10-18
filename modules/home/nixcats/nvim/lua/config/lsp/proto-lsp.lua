vim.lsp.config("buf-lsp", {
  cmd = { "buf", "lsp", "serve" },
  filetypes = { "proto" },
  root_marks = { "buf.yaml", ".git" }
})
vim.lsp.enable("buf-lsp")
