vim.opt.signcolumn = "yes"

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },

  virtual_text = {
    spacing = 4,
    source = "always",
    prefix = "● ",
  },
  severity_sort = true,
  float = {
    source = "always"
  }
})
