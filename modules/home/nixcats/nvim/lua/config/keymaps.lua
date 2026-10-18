vim.g.mapleader = " "
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

vim.keymap.set("n", "H", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "J", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "K", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "L", "<C-w>l", { noremap = true, silent = true })
