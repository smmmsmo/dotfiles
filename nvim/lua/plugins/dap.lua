return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "javadbg", "javatest" },
        automatic_installation = true,
        handlers = {},
      })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.35 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          { elements = { "repl", "console" }, position = "bottom", size = 10 },
        },
      })
      require("nvim-dap-virtual-text").setup({ commented = true })

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- codelldb for C/C++ (installed via mason-nvim-dap).
      local codelldb_dir = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
      if vim.fn.isdirectory(codelldb_dir) == 1 then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_dir .. "/extension/adapter/codelldb",
            args = { "--port", "${port}" },
          },
        }
      end

      local cpp_config = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.cpp = cpp_config
      dap.configurations.c = cpp_config

      -- Breakpoint signs.
      local signs = {
        DapBreakpoint = { text = "●", texthl = "DiagnosticSignError" },
        DapBreakpointCondition = { text = "◆", texthl = "DiagnosticSignWarn" },
        DapLogPoint = { text = "◆", texthl = "DiagnosticSignInfo" },
        DapStopped = { text = "→", texthl = "DiagnosticSignOk", linehl = "Visual" },
        DapBreakpointRejected = { text = "●", texthl = "DiagnosticSignHint" },
      }
      for name, sign in pairs(signs) do
        vim.fn.sign_define(name, sign)
      end
    end,
  },
}
