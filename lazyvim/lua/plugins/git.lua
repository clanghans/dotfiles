return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Git status (Fugitive)" },
      { "<leader>gG", "<cmd>Git<cr>", desc = "Git status (Fugitive, cwd)" },
    },
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
