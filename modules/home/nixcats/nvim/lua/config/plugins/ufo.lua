require("lze").load({
  {
    "nvim-ufo",
    for_cat = "tools",
    opts = {},
    after = function ()
      require("ufo").setup({})
    end
  }
})

vim.keymap.set("n", "<leader>f", "za")
