return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- 🚀 LAZY LOADING: Se carga solo cuando se guarda
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>f", function() require("conform").format({ async = true }) end, mode = "n", desc = "Formatear" },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      notify_on_error = true,
    })
  end,
}