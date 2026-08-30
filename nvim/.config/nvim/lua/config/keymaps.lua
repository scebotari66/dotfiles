-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Move vertically faster
map({ "n", "x" }, "J", "5j", { desc = "Move Down 5 Lines" })
map({ "n", "x" }, "K", "5k", { desc = "Move Up 5 Lines" })

map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save All" })

-- System clipboard
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to Clipboard" })
map("x", "<leader>d", '"+d', { desc = "Delete to Clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from Clipboard" })
map({ "n", "x" }, "<leader>P", '"+P', { desc = "Paste from Clipboard (before)" })
