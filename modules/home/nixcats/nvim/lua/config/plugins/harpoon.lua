require("harpoon").setup({
  tabline = true,
  tabline_prefix = "   ",
})

vim.keymap.set("n", "<leader>m", function()
  require("harpoon.mark").add_file()

  vim.notify("Harpooned file", vim.log.levels.INFO, {
    title = "Harpoon",
  })
end, { desc = "Harpoon a file" })

vim.keymap.set("n", "<leader>h", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Toggle quick harpoon menu" })

vim.keymap.set("n", "m.", function()
  require("harpoon.ui").nav_next()
end, { desc = "Navigate to next mark" })

vim.keymap.set("n", "m,", function()
  require("harpoon.ui").nav_prev()
end, { desc = "Navigate to previous mark" })

for i = 1, 9 do
  vim.keymap.set("n", "m" .. i, function()
    require("harpoon.ui").nav_file(i)
  end, { desc = "Navigate to file " .. i })
end
