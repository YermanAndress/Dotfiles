return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    -- Configure which-key to automatically show help for <leader> prefix
    triggers = {
      { "<leader>", mode = { "n", "v" } },
    },
    -- Replacements for deprecated key_labels
    replace = {
      key = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
    },
    -- Defer loading for operators
    defer = function(ctx)
      return ctx.mode == "n" and vim.bo.filetype ~= "TelescopePrompt" and vim.bo.filetype ~= "oil"
    end,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    popup_margins = { 1, 1, 1, 1 },
    popup_window_border = false,
    label = true,
    disable = {
      ft = {},
      bt = {},
    },
  },
}