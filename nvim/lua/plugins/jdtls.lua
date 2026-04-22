-- nvim-jdtls is loaded only when a Java file is opened (via ftplugin/java.lua).
-- This spec just declares the dep so lazy.nvim downloads/keeps it synced.
return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
  },
}
