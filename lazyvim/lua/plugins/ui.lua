return {
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
        tab_char = "▏",
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▏",
    },
  },
}
