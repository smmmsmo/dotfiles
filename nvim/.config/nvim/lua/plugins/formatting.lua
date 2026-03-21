-- ============================================================================
-- Formatting Configuration
-- ============================================================================
-- Uses conform.nvim for formatting with language-specific formatters
-- Format on save enabled by default

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "ruff_format", "ruff_fix" },

        -- JavaScript/TypeScript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },

        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },

        -- Go
        go = { "goimports", "gofumpt" },

        -- C/C++
        c = { "clang-format" },
        cpp = { "clang-format" },

        -- Java
        java = { "google-java-format" },

        -- Rust
        rust = { "rustfmt" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        -- SQL
        sql = { "sql_formatter" },

        -- Docker
        dockerfile = { "hadolint" },

        -- TOML
        toml = { "taplo" },

        -- XML
        xml = { "xmllint" },

        -- Catch all for files without formatter
        ["_"] = { "trim_whitespace" },
      },

      -- Format on save settings
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = true,
      },

      -- Custom formatter configurations
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        prettier = {
          prepend_args = { "--tab-width", "2", "--single-quote" },
        },
      },
    },
  },

}
