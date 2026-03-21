-- ============================================================================
-- Go Language Configuration
-- ============================================================================
-- Uses gopls for LSP, delve for debugging
-- Includes testing, coverage, and struct tag generation

return {
  -- Go LSP enhancements
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },

  -- Treesitter for Go
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
      })
    end,
  },

  -- Go tools integration
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      lsp_cfg = false, -- We use lspconfig directly
      lsp_gofumpt = true,
      lsp_keymaps = false, -- Use our own keymaps
      dap_debug = true,
      dap_debug_gui = true,
    },
    keys = {
      { "<leader>cgt", "<cmd>GoTest<cr>", desc = "Go Test" },
      { "<leader>cgT", "<cmd>GoTestFunc<cr>", desc = "Go Test Function" },
      { "<leader>cgc", "<cmd>GoCoverage<cr>", desc = "Go Coverage" },
      { "<leader>cga", "<cmd>GoAddTag<cr>", desc = "Add Struct Tags" },
      { "<leader>cgr", "<cmd>GoRmTag<cr>", desc = "Remove Struct Tags" },
      { "<leader>cgi", "<cmd>GoImpl<cr>", desc = "Implement Interface" },
      { "<leader>cgf", "<cmd>GoFillStruct<cr>", desc = "Fill Struct" },
      { "<leader>cge", "<cmd>GoIfErr<cr>", desc = "Generate if err" },
    },
  },
}
