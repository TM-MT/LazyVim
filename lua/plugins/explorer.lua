return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- @type snacks.picker.explorer.Config
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
