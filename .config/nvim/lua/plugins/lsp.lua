return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPost", "BufNewFile" }, -- Agregada coma aquí
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "pyright", "bashls", "yamlls", "jsonls",
        "ts_ls", "html", "cssls",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
      }, 
    })

    -- Autocomando de LspAttach (Atajos de teclado)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local map = vim.keymap.set
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        map("n", "<leader>e", vim.diagnostic.open_float, opts)
      end,
    })
  end,
}