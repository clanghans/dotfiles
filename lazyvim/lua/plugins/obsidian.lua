return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
        {
          name = "work",
          path = "~/vaults/work",
        },
      },
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian New" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian File Search" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian Search" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Obsidian Rename" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Obsidian Today" },
      { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian Yesterday" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        {
          { "<leader>o", group = "Obsidian" },
        },
      },
    },
  },
}
