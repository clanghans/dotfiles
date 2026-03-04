return {
  -- Setup up format with new `conform.nvim`
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        shell = { "shfmt" },
        -- zsh = { "shfmt" }, -- shfmt doesn't support zsh syntax (e.g. $+commands[])
        -- dart = { "dart format" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost" },
      linters_by_ft = {
        python = { "ruff", "mypy" },
        shell = { "shellcheck" },
        zsh = { "shellcheck" },
        yaml = { "yamllint" },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        mypy = {
          -- Use the `condition` option to dynamically enable/disable linters
          -- condition = function(ctx)
          --   return vim.fn.executable("mypy") == 1
          -- end,
          -- Override the default args for the linter
          args = function(params)
            -- Try to find the Python executable from a virtual environment
            local venv_path = os.getenv("VIRTUAL_ENV")
            local python_executable = venv_path and venv_path .. "/bin/python" or "python3"
            return { "--python-executable", python_executable }
          end,
        },
      },
    },
  },
}
