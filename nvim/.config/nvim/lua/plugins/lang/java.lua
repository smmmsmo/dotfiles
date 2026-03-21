-- ============================================================================
-- Java Language Configuration
-- ============================================================================
-- Uses jdtls (Eclipse JDT Language Server) via nvim-jdtls
-- Includes debugging, testing, and Maven/Gradle support

return {
  -- Java-specific LSP setup is handled by LazyVim extras
  -- This file adds custom configurations on top

  -- Additional Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "java",
        "groovy", -- for Gradle
        "xml",    -- for pom.xml
      })
    end,
  },

  -- Configure nvim-jdtls with additional settings
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.junit.Assert.*",
              "org.junit.Assume.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
              "org.mockito.ArgumentMatchers.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
      })
      return opts
    end,
  },
}
