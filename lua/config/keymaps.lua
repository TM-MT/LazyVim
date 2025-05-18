-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

keymap.set({ "n", "i" }, "<F5>", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run Test (File)" })
keymap.set({ "n", "i" }, "S-<F5>", function()
  require("neotest").run.run(vim.uv.cwd())
end, { desc = "Run All Test In cwd" })
keymap.set({ "n", "i" }, "<F6>", vim.lsp.buf.rename, { desc = "Rename" })
keymap.set({ "n", "i" }, "<F12>", vim.lsp.buf.definition, { desc = "Goto definition" })
keymap.set({ "n", "i" }, "S-<F12>", vim.lsp.buf.references, { desc = "Goto references" })
