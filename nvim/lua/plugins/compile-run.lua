-- Compile-and-run for C / C++ / Java via a floating terminal.
-- If the current directory (or buffer dir) has an `input.txt`, it's piped as stdin.
return {
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    keys = {
      { "<leader>rr", function() require("cp.runner").run() end, desc = "Compile & run (with input.txt if present)" },
      { "<leader>rc", function() require("cp.runner").compile() end, desc = "Compile only" },
      { "<leader>ri", function() require("cp.runner").edit_input() end, desc = "Edit input.txt" },
      { "<leader>ro", function() require("cp.runner").edit_output() end, desc = "Edit expected_output.txt" },
      { "<leader>rd", function() require("cp.runner").diff_output() end, desc = "Diff output vs expected" },
    },
  },
}
