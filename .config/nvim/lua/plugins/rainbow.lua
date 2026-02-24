return {
  "hiphish/rainbow-delimiters.nvim",
  event = "BufReadPost", -- 🚀 Se carga solo al abrir archivos
  config = function()
    local rainbow_delimiters = require('rainbow-delimiters')
    
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'], -- Global para lo demás
        html = function() return nil end,             -- DESACTIVA rainbow en HTML
        xml = function() return nil end,              -- También en XML si quieres
      },
      -- El resto de tu configuración (query, highlight, etc.)
      query = {
        [''] = 'rainbow-delimiters',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end
}