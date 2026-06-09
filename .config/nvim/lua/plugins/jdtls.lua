return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local mason_pkg_path = vim.fn.stdpath("data") .. "/mason/packages/java-language-server"
    local jdtls_bin = mason_pkg_path .. "/java-language-server"

    if vim.fn.executable(jdtls_bin) ~= 1 then
      vim.notify("nvim-jdtls: java-language-server not found in Mason. Run :MasonInstall java-language-server", vim.log.levels.WARN)
      return
    end

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name

    require("jdtls").start_or_attach({
      cmd = { jdtls_bin, "-configuration", workspace_dir .. "/config", "-data", workspace_dir .. "/data" },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
      handlers = {
        ["client/registerCapability"] = function(err, params, client)
          if params and params.registrations then
            return vim.lsp.handlers["client/registerCapability"](err, params, client)
          end
          return true
        end,
      },
      settings = {
        java = {
          completion = { favoriteStaticMembers = { "org.assertj.core.api.Assertions.*" } },
          configuration = { runtimes = {} },
          eclipse = { downloadSources = true },
          maven = { downloadSources = true },
          implementationsCodeLens = { enabled = false },
          referencesCodeLens = { enabled = false },
          references = { includeDecompiledSources = true },
          signatureHelp = { enabled = true },
        },
      },
      init_options = {
        bundles = {},
      },
    })
  end,
}
