return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end
    configs.setup({
      prefer_git = false,
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "markdown",
        "python", "javascript", "typescript", "tsx",
        "html", "css", "c", "rust", "java",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}