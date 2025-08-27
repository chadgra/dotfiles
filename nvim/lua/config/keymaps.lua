-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymaps for working with buffers
vim.keymap.set("n", "<leader><delete>", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })
vim.keymap.set("n", "<leader>bo", Snacks.bufdelete.other, { desc = "Close Other Buffers" })
vim.keymap.set("n", "<leader><CR>", "<cmd>%bd<cr>", { desc = "Close All Buffers" })

-- Keymaps for insert mode
  -- 'jk' is handled by better-escape.lua
  -- vim.keymap.set("i", "jk", "<Esc>", { desc = "Normal mode" })
  vim.keymap.set("i", ";;", "<C-o>", { desc = "Normal mode single operation" })
