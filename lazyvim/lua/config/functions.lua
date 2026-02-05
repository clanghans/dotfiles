function remotePermalink()
  -- Get the current buffer's file name
  local file_name = vim.api.nvim_buf_get_name(0)
  -- Get the current cursor position - remember indexed from 1
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Calculate the length of the current line
  local line_length = string.len(vim.api.nvim_get_current_line()) + 1

  -- Construct the command for the python script
  local command = "repo_remote_permalink.sh " .. file_name .. " " .. cursor_pos[1] .. " " .. line_length

  -- Debug: Print the constructed command to the message area
  vim.notify("Executing command: " .. command, vim.log.levels.DEBUG)

  -- Call the python script to get the permalink
  local result = vim.fn.system(command)

  -- Notify the result and copy it to clipboard
  vim.notify(result)
  vim.fn.setreg("+", result)
end

vim.api.nvim_create_user_command("RemotePermalink", "lua remotePermalink()", {})
