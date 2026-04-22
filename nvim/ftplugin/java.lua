-- Start jdtls for this Java buffer. Bootstraps from Mason install paths.
local ok_jdtls, jdtls = pcall(require, "jdtls")
if not ok_jdtls then return end

local mason_pkg_root = vim.fn.stdpath("data") .. "/mason/packages"
local function mason_path(name)
  local p = mason_pkg_root .. "/" .. name
  if vim.fn.isdirectory(p) == 1 then return p end
  return nil
end

local jdtls_path = mason_path("jdtls")
if not jdtls_path then
  vim.notify("jdtls not installed via Mason yet. Run :MasonInstall jdtls", vim.log.levels.WARN)
  return
end

-- Platform-specific launcher config.
local system = (function()
  local uname = vim.uv.os_uname().sysname
  if uname == "Darwin" then return "mac" end
  if uname == "Linux" then return "linux" end
  return "win"
end)()

local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local config_dir = jdtls_path .. "/config_" .. system

-- Workspace root: marker-based, then fallback to file parent.
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }
local root_dir = require("jdtls.setup").find_root(root_markers) or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")

local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Bundles: debugger + tests.
local bundles = {}
local jdbg = mason_path("java-debug-adapter")
if jdbg then
  vim.list_extend(bundles, vim.split(vim.fn.glob(jdbg .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n"))
end
local jtest = mason_path("java-test")
if jtest then
  vim.list_extend(bundles, vim.split(vim.fn.glob(jtest .. "/extension/server/*.jar"), "\n"))
end

local caps = _G.LspCapabilities or vim.lsp.protocol.make_client_capabilities()

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx2g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },
  root_dir = root_dir,
  capabilities = caps,
  settings = {
    java = {
      eclipse = { downloadSources = true },
      configuration = { updateBuildConfiguration = "interactive" },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      inlayHints = { parameterNames = { enabled = "all" } },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" }, useBlocks = true },
    },
  },
  flags = { allow_incremental_sync = true },
  init_options = { bundles = bundles, extendedClientCapabilities = jdtls.extendedClientCapabilities },
  on_attach = function(client, bufnr)
    if _G.LspOnAttach then _G.LspOnAttach(client, bufnr) end
    jdtls.setup_dap({ hotcodereplace = "auto" })
    local ok_mj = pcall(require, "jdtls.dap")
    if ok_mj then require("jdtls.dap").setup_dap_main_class_configs() end

    local map = function(l, r, d) vim.keymap.set("n", l, r, { buffer = bufnr, desc = d }) end
    map("<leader>lo", jdtls.organize_imports, "Organize imports")
    map("<leader>lv", jdtls.extract_variable, "Extract variable")
    map("<leader>lC", jdtls.extract_constant, "Extract constant")
    map("<leader>lT", function() require("jdtls.dap").test_class() end, "Test class")
    map("<leader>lt", function() require("jdtls.dap").test_nearest_method() end, "Test nearest method")
  end,
}

jdtls.start_or_attach(config)
