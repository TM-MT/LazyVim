return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = {
        prompts = {
          explain_changes = [[Please explain the latest changes by function from three perspectives:
          functionality, changes, and scope of impact of the changes.]],
        },
      },
    },
    keys = {
      {
        "<leader>as",
        function()
          require("sidekick.cli").select({ filter = { installed = true } })
        end,
        mode = { "n", "v", "t", "x" },
        desc = "Select CLI (Installed)",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "copilot", focus = true })
        end,
        mode = { "n", "v", "t", "x" },
        desc = "Copilot",
      },
      {
        "<leader>al",
        function()
          require("sidekick.cli").send({ msg = "{line}" })
        end,
        mode = { "n", "v" },
        desc = "Send Line",
      },
    },
  },
}
