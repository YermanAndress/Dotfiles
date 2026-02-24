local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" }, -- Importa automáticamente todos los archivos en lua/plugins/
  },
  defaults = {
    -- lazy = true, -- 🚀 LAZY LOADING: Carga solo cuando sea necesario
    lazy = true,

    version = false, -- usa los últimos cambios
  },
  checker = { enabled = true }, -- avisar si hay actualizaciones de plugins
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
      },
    },
  },
})
