return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Neogit" },
    },
    opts = {},
  },

  {
    "emmanueltouzery/agitator.nvim",
    keys = {
      {
        "<leader>gm",
        function()
          require("agitator").git_time_machine()
        end,
        desc = "Git time machine",
      },
    },
  },
}
