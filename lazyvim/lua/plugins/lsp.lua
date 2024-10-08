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
      -- -- pyright will be automatically installed with mason and loaded with lspconfig
      -- pyright = {
      --   settings = {
      --     pyright = {
      --       disableOrganizeImports = true, -- Using Ruff
      --     },
      --     python = {
      --       analysis = {
      --         ignore = { "*" }, -- Using Ruff
      --       },
      --     },
      --   },
      --   capabilities = (function()
      --     local capabilities = vim.lsp.protocol.make_client_capabilities()
      --     capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
      --     return capabilities
      --   end)(),
      -- },
      --
      -- ruff_lsp = {
      --   on_attach = function(client, bufnr)
      --     client.server_capabilities.hoverProvider = false
      --
      --     vim.api.nvim_create_autocmd("BufWritePre", {
      --       callback = function()
      --         local params = vim.lsp.util.make_range_params()
      --         params.context = { only = { "source.organizeImports" } }
      --         local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1000)
      --         for _, res in pairs(result or {}) do
      --           for _, action in pairs(res.result or {}) do
      --             if action.kind == "source.organizeImports" then
      --               vim.lsp.buf.execute_command(action)
      --             end
      --           end
      --         end
      --       end,
      --       buffer = bufnr,
      --     })
      --   end,
      -- },
      -- },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = "all",
    },
  },
  -- {
  --   -- disable context because it's fucking with tmux
  --   "nvim-treesitter/nvim-treesitter-context",
  --   enabled = false,
  -- },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      local ensure_installed = {
        -- python
        "ruff-lsp", -- lsp
        "ruff", -- linter (but used as formatter)
        "pyright", -- lsp
        "black", -- formatter
        "mypy", -- linter

        -- lua
        "lua-language-server", -- lsp
        "stylua", -- formatter

        -- shell
        "bash-language-server", -- lsp
        "shfmt", -- formatter
        "shellcheck", -- linter

        -- yaml
        "yamllint", -- linter

        -- rust
        "rust-analyzer", -- lsp
      }
      -- extend opts.ensure_installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, ensure_installed)

      -- remove from opts.ensure_installed
      local ensure_not_installed = {}
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not vim.tbl_contains(ensure_not_installed, tool)
      end, opts.ensure_installed)
    end,
  },
}
