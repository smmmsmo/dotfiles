return {
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { [[<C-\>]], desc = "Toggle terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=12<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Vertical terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      shade_terminals = true,
      float_opts = { border = "rounded" },
      size = function(term)
        if term.direction == "horizontal" then return 12 end
        if term.direction == "vertical" then return math.floor(vim.o.columns * 0.4) end
      end,
    },
  },
}
