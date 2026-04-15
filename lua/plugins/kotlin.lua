-- Override LazyVim's kotlin extra to use kotlin_lsp instead of kotlin_language_server
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable kotlin_language_server (set by lazyvim.plugins.extras.lang.kotlin)
        kotlin_language_server = { enabled = false },
        kotlin_lsp = {},
      },
    },
  },
}
