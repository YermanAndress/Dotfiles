return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- 1. Setup básico de Mason
    require("mason").setup()

    -- 2. Capacidades para el autocompletado
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    -- 3. Configuración de servidores mediante Mason-Lspconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "pyright", "bashls", "yamlls", "jsonls",
        "ts_ls", "html", "cssls", "eslint",
      },
      handlers = {
        -- Handler por defecto para todos los servidores
        function(server_name)
          local opts = {
            capabilities = capabilities,
          }
          require("lspconfig")[server_name].setup(opts)
        end,
      }, 
    })

    -- 4. Autocomando de LspAttach (Atajos de teclado solo cuando hay un LSP activo)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local map = vim.keymap.set
        
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>d", vim.diagnostic.open_float, opts)
      end,
    })
  end,
}
