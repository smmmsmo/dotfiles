-- ============================================================================
-- Terminal Configuration
-- ============================================================================
-- Terminal integration with tmux and floating terminals

return {
  -- Tmux Navigator (seamless navigation between vim and tmux)
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Navigate Left (Vim/Tmux)" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Navigate Down (Vim/Tmux)" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Navigate Up (Vim/Tmux)" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Navigate Right (Vim/Tmux)" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Navigate Previous (Vim/Tmux)" },
    },
  },

  -- Tmux Runner (send commands to tmux pane)
  {
    "preservim/vimux",
    cmd = {
      "VimuxRunCommand",
      "VimuxRunLastCommand",
      "VimuxOpenRunner",
      "VimuxCloseRunner",
      "VimuxZoomRunner",
      "VimuxInspectRunner",
      "VimuxInterruptRunner",
      "VimuxPromptCommand",
      "VimuxClearTerminalScreen",
    },
    init = function()
      -- Vimux configuration
      vim.g.VimuxHeight = "30"
      vim.g.VimuxOrientation = "v"
      vim.g.VimuxUseNearest = 1
      vim.g.VimuxResetSequence = "q C-u"
      vim.g.VimuxPromptString = "Command: "
    end,
    keys = {
      { "<leader>vp", "<cmd>VimuxPromptCommand<cr>", desc = "Prompt Command" },
      { "<leader>vl", "<cmd>VimuxRunLastCommand<cr>", desc = "Run Last Command" },
      { "<leader>vi", "<cmd>VimuxInspectRunner<cr>", desc = "Inspect Runner" },
      { "<leader>vz", "<cmd>VimuxZoomRunner<cr>", desc = "Zoom Runner" },
      { "<leader>vc", "<cmd>VimuxCloseRunner<cr>", desc = "Close Runner" },
      { "<leader>vC", "<cmd>VimuxClearTerminalScreen<cr>", desc = "Clear Terminal" },
      { "<leader>vx", "<cmd>VimuxInterruptRunner<cr>", desc = "Interrupt Runner" },
      { "<leader>vo", "<cmd>VimuxOpenRunner<cr>", desc = "Open Runner" },
    },
  },

  -- ToggleTerm for floating terminals
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Custom terminals
      local Terminal = require("toggleterm.terminal").Terminal

      -- Lazygit terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
      })

      function _G.lazygit_toggle()
        lazygit:toggle()
      end

      -- Htop terminal
      local htop = Terminal:new({
        cmd = "htop",
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })

      function _G.htop_toggle()
        htop:toggle()
      end

      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        direction = "horizontal",
      })

      function _G.python_toggle()
        python:toggle()
      end

      -- Node REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "horizontal",
      })

      function _G.node_toggle()
        node:toggle()
      end
    end,
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Floating Terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical Terminal" },
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tg", "<cmd>lua lazygit_toggle()<cr>", desc = "LazyGit" },
      { "<leader>tH", "<cmd>lua htop_toggle()<cr>", desc = "Htop" },
      { "<leader>tp", "<cmd>lua python_toggle()<cr>", desc = "Python REPL" },
      { "<leader>tn", "<cmd>lua node_toggle()<cr>", desc = "Node REPL" },
      -- Terminal mode mappings
      { "<esc>", [[<C-\><C-n>]], mode = "t", desc = "Exit Terminal Mode" },
      { "<C-h>", [[<cmd>wincmd h<cr>]], mode = "t", desc = "Navigate Left" },
      { "<C-j>", [[<cmd>wincmd j<cr>]], mode = "t", desc = "Navigate Down" },
      { "<C-k>", [[<cmd>wincmd k<cr>]], mode = "t", desc = "Navigate Up" },
      { "<C-l>", [[<cmd>wincmd l<cr>]], mode = "t", desc = "Navigate Right" },
    },
  },

  -- Better terminal colors
  {
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = true,
  },
}
