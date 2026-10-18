require("lze").load({
  {
    "oil.nvim",
    for_cat = "tools",
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open oil buffer",
      },
    },
    after = function()
      require("oil").setup({
        view_options = {
          show_hidden = true
        }
      })
    end
  }
})
