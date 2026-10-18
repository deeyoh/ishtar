require("telescope").setup({})

vim.keymap.set("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, {
  desc = "Telescope files",
})

vim.keymap.set("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, {
  desc = "Grep files",
})
