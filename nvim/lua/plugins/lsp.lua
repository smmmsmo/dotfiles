return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "clangd", "lua_ls", "jdtls", "pyright", "bashls" },
      automatic_installation = true,
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "clang-format",
        "stylua",
        "google-java-format",
        "codelldb",
        "java-debug-adapter",
        "java-test",
      },
      run_on_start = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- Diagnostics UI.
      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      -- Hover / signature help with rounded borders.
      local orig_hover = vim.lsp.buf.hover
      vim.lsp.buf.hover = function() orig_hover({ border = "rounded" }) end
      local orig_sig = vim.lsp.buf.signature_help
      vim.lsp.buf.signature_help = function() orig_sig({ border = "rounded" }) end

      -- Base capabilities with cmp_nvim_lsp.
      local caps = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then caps = cmp_lsp.default_capabilities(caps) end

      -- Expose for jdtls ftplugin.
      _G.LspCapabilities = caps

      -- Shared on_attach via autocmd (buffer-local keymaps).
      _G.LspOnAttach = function(client, bufnr)
        local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc }) end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", "<cmd>Telescope lsp_references<cr>", "References")
        map("gi", vim.lsp.buf.implementation, "Implementation")
        map("gy", vim.lsp.buf.type_definition, "Type definition")
        map("K", vim.lsp.buf.hover, "Hover")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("<leader>lr", vim.lsp.buf.rename, "Rename")
        map("<leader>la", vim.lsp.buf.code_action, "Code action")
        map("<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        map("<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
        map("<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols")
        if client and client:supports_method("textDocument/inlayHint") then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LspAttachKeymaps", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          _G.LspOnAttach(client, args.buf)
        end,
      })

      -- Per-server overrides layered on top of nvim-lspconfig's built-in defaults
      -- (those ship as `lsp/<name>.lua` in the plugin and are picked up automatically).
      vim.lsp.config("*", { capabilities = caps })

      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
            hint = { enable = true },
          },
        },
      })

      -- Enable servers (jdtls intentionally excluded — owned by ftplugin/java.lua).
      vim.lsp.enable({ "clangd", "lua_ls", "pyright", "bashls" })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>lF", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format (conform)" },
    },
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        java = { "google-java-format" },
        python = { "black" },
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 1500, lsp_fallback = true }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then vim.b.disable_autoformat = true else vim.g.disable_autoformat = true end
      end, { desc = "Disable autoformat-on-save", bang = true })
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Enable autoformat-on-save" })
    end,
  },
}
