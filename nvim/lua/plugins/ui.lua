return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_diagnostic" } } },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then return "" end
              local names = {}
              for _, c in ipairs(clients) do table.insert(names, c.name) end
              return " " .. table.concat(names, ",")
            end,
          },
          "encoding", "fileformat", "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "toggleterm", "mason", "quickfix" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        show_close_icon = false,
        show_buffer_close_icons = true,
        always_show_bufferline = false,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", text_align = "center", separator = true },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in explorer" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
      },
      window = { width = 32 },
      default_component_configs = {
        indent = { with_markers = true, with_expanders = true },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>r", group = "run/cp" },
        { "<leader>s", group = "split" },
        { "<leader>t", group = "test/cp" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      return {
        theme = "hyper",
        config = {
          week_header = { enable = true },
          shortcut = {
            { desc = " New file", group = "String", action = "enew", key = "n" },
            { desc = " Find file", group = "Label", action = "Telescope find_files", key = "f" },
            { desc = " Recent", group = "Number", action = "Telescope oldfiles", key = "r" },
            { desc = " New CP", group = "Constant", action = "enew | setfiletype cpp", key = "c" },
            { desc = "󰒲 Lazy", group = "Special", action = "Lazy", key = "l" },
            { desc = " Quit", group = "Error", action = "qa", key = "q" },
          },
          project = { enable = true, limit = 6 },
          mru = { limit = 8 },
          footer = { "", "⚡ Ready." },
        },
      }
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = { timeout = 2500, stages = "fade", render = "compact", top_down = false },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
}
