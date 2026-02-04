return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  ft = { "lua", "vim", "vimdoc", "bash", "markdown", "python", 
        "javascript", "typescript", "html", "css", "c", "rust" }, 
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}