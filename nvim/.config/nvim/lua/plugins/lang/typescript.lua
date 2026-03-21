-- ============================================================================
-- TypeScript/JavaScript Language Configuration
-- ============================================================================
-- Uses ts_ls (TypeScript Language Server) and Volar for Vue
-- Includes ESLint, Prettier, and testing support

return {
  -- TypeScript LSP enhancements
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
      },
    },
  },

  -- Additional Treesitter parsers for JS ecosystem
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "scss",
        "vue",
        "svelte",
        "astro",
        "graphql",
        "prisma",
      })
    end,
  },

  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    opts = {},
    keys = {
      { "<leader>cps", "<cmd>lua require('package-info').show()<cr>", desc = "Show Package Versions" },
      { "<leader>cpu", "<cmd>lua require('package-info').update()<cr>", desc = "Update Package" },
      { "<leader>cpd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete Package" },
      { "<leader>cpi", "<cmd>lua require('package-info').install()<cr>", desc = "Install Package" },
      { "<leader>cpc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change Package Version" },
    },
  },
}
