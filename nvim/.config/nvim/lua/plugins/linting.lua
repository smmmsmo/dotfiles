-- ============================================================================
-- Linting Configuration
-- ============================================================================
-- Uses nvim-lint for linting with language-specific linters
-- Linting happens on save and insert leave

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue = { "eslint_d" },
        svelte = { "eslint_d" },

        -- Python
        python = { "ruff", "mypy" },

        -- Go
        go = { "golangcilint" },

        -- Shell
        sh = { "shellcheck" },
        bash = { "shellcheck" },

        -- Docker
        dockerfile = { "hadolint" },

        -- YAML
        yaml = { "yamllint" },

        -- Markdown
        markdown = { "markdownlint" },

        -- JSON
        json = { "jsonlint" },

        -- SQL
        sql = { "sqlfluff" },

        -- GitHub Actions
        ["yaml.github"] = { "actionlint" },
      },

      -- Events to trigger linting
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    },
  },

}
