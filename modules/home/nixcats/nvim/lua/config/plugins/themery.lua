require("lze").load({
  {
    "themery.nvim",
    for_cat = "tools",
    keys = {
      {
        "<leader>st",
        "<cmd>Themery<CR>",
        desc = "Open themery",
      },
    },
    after = function()
      require("themery").setup({
        themes = {
          {
            name = "hm",
            colorscheme = "hatsunemiku",
          },
          {
            name = "gruber",
            colorscheme = "gruber-darker"
          },
        }
      })
    end
  }
})
