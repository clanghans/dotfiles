return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<leader>/", LazyVim.pick("live_grep_glob"), desc = "Grep Glob (Root Dir)" },
      { "<leader><space>", LazyVim.pick("commands"), desc = "Commands" },
      { "<leader>'", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>*", LazyVim.pick("grep_cword"), desc = "Word (Root Dir)" },
    },
  },
}
