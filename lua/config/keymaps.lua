-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set({ "n", "i" }, "<F12>", vim.lsp.buf.definition, { desc = "Goto definition" })
keymap.set({ "n", "i" }, "S-<F12>", vim.lsp.buf.references, { desc = "Goto references" })
keymap.set({ "n", "i" }, "<F6>", vim.lsp.buf.rename, { desc = "Rename" })
