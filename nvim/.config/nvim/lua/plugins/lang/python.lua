-- ============================================================================
-- Python Language Configuration
-- ============================================================================
-- Uses pyright for type checking and ruff for linting/formatting
-- Includes debugging with debugpy and virtual environment support

return {
  -- Python LSP enhancements
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {
          -- Ruff handles linting and formatting
          init_options = {
            settings = {
              lineLength = 100,
              indent = 4,
            },
          },
        },
      },
    },
  },

  -- Treesitter for Python
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
        "toml", -- for pyproject.toml
        "requirements",
      })
    end,
  },

  -- Virtual environment selector
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "VenvSelect",
    opts = {
      name = { "venv", ".venv", "env", ".env" },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Virtual Environment" },
    },
  },
}
