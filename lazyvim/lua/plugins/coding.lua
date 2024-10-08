return {
  -- Setup up format with new `conform.nvim`
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff", "ruff_fix", "ruff_format" },
        shell = { "shfmt" },
        zsh = { "shfmt" },
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
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
  },
}
