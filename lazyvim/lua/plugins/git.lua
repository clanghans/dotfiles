return {
  {
    -- dir = "~/ws/neogit",
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
    lazy = true,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gG", "<cmd>Neogit cwd=getcwd()<cr>", desc = "Neogit" },
    },
  },

  {
    "nvim-mini/mini-git",
    version = false,
    main = "mini.git",
    lazy = true,
    config = true,
    keys = {

      { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add current file" },
    },
  },
}
