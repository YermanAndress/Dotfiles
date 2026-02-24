return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy", -- 🚀 Se carga después de los plugins críticos
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "ayu",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "neo-tree", "alpha" },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { 
          { "filename", path = 1 },
          "diagnostics",
        },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
