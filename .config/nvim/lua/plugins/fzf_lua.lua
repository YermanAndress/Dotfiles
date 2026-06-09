return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({
      "telescope",
      -- or choose `ivy` for a different layout
      -- or choose `default`
      -- or create your own: https://github.com/ibhagwan/fzf-lua#using-custom-calltree
      -- see sidebar for full list of available "trees"
      -- NOTE: the `telescope` previewer uses bat or cat if unavailable
      -- and fzf's built-in previewer rather than telescope's previewer
      -- which was the main bottleneck in telescope.nvim
      -- so this is much faster!
    })
  end,
}