return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  lazy = false,
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      window = {
        position = "right",
        width = 35,
      },
      filesystem = {
        -- Hijack netrw cuando abres un directorio
        hijack_netrw_behavior = "open_default",
        
        -- Sigue el archivo actual
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },

        -- Compacta carpetas vacías
        group_empty_dirs = true,

        -- Filtros
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    })
  end,
}