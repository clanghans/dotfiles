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
    lazy = false,
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", "Neogit" },
      { "<leader>gG", "<cmd>Neogit cwd=getcwd()<cr>", "Neogit" },
    },
  },
}
