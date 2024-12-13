-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 999
vim.g.autoformat = false

vim.opt.spelllang = { "en", "de" }

vim.opt.clipboard = "unnamedplus"

-- persistent undo
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- make zsh files recognized as sh for bash-ls & treesitter
-- credits: https://nanotipsforvim.prose.sh/treesitter-and-lsp-support-for-zsh
local zsh_extension = {  zsh = "sh", sh = "sh" }
vim.filetype.add(zsh_extension)

local zsh_files = { ".zshrc", ".zshenv", "zshrc", "zshenv" }
for _, filename in ipairs(zsh_files) do
  vim.filetype.add({filename= {[filename] = "sh"}})
end

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
