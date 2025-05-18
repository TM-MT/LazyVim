-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.relativenumber = false
opt.smoothscroll = false
-- JP is not available
-- see https://ftp.nluug.nl/pub/vim/runtime/spell/
opt.spelllang = { "en" }
