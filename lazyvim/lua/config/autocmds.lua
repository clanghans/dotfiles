-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Now, create the autocommand within that group
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Assuming that you are using the built-in LSP, you can disable diagnostics like this:
    vim.diagnostic = require("vim.diagnostic")
    vim.diagnostic.enable(false)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("FixDartCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "// %s"
  end,
  pattern = "dart",
})

vim.api.nvim_create_autocmd({ "VimEnter", "VimLeave" }, {
  callback = function()
    if vim.env.TMUX_PLUGIN_MANAGER_PATH then
      vim.uv.spawn(
        vim.env.TMUX_PLUGIN_MANAGER_PATH .. "/tmux-window-name/scripts/rename_session_windows.py",
        {},
        function(code, signal)
          print("Process exited with code", code, "and signal", signal)
        end
      )
    end
  end,
})
