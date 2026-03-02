return {
  -- configure LSP
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        bashls = {
          cmd = { "bash-language-server", "start" },
          filetypes = { "sh", "bash", "zsh" },
        },
        dartls = {
          cmd = { "dart", "language-server", "--lsp" },
          filetypes = { "dart" },
        },
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "csv",
        "dart",
        "dockerfile",
        "git_config",
        "go",
        "html",
        "javascript",
        "jq",
        "json",
        "latex",
        "lua",
        "make",
        "markdown",
        "python",
        "rust",
        "starlark",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "xml",
        "yaml"
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local ensure_installed = {
        -- python
        "ruff",     -- linter/formatter
        "pyright",  -- lsp
        "mypy",     -- linter

        -- lua
        "lua-language-server", -- lsp
        "stylua",              -- formatter

        -- shell
        "bash-language-server", -- lsp
        "shfmt",                -- formatter
        "shellcheck",           -- linter

        -- yaml
        "yamllint", -- linter

        -- rust
        "rust-analyzer", -- lsp
      }
      -- extend opts.ensure_installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, ensure_installed)
    end,
  },
}
