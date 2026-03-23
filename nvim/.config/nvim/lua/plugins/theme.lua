return {
  -- Keep the active theme explicit in its own file.
  -- The theme hot-reload helper expects this module to exist.
  -- Theme choices you can switch to later:
  -- colorscheme = "tokyonight"
  -- colorscheme = "catppuccin"
  -- colorscheme = "gruvbox"
  -- colorscheme = "kanagawa"
  -- colorscheme = "rose-pine"
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
