return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    local nvim_tmux_nav = require("nvim-tmux-navigation")
    -- nvim_tmux_nav.setup({
    --   disable_when_zoomed = true, -- defaults to false
    -- })
  end,

  keys = {
    {
      "<c-h>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
      end,
      desc = "tmux navigate left",
    },
    {
      "<c-j>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateDown()
      end,
      desc = "tmux navigate down",
    },
    {
      "<c-k>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateUp()
      end,
      desc = "tmux navigate up",
    },
    {
      "<c-l>",
      function()
        require("nvim-tmux-navigation").NvimTmuxNavigateRight()
      end,
      desc = "tmux navigate right",
    },
  },
}
