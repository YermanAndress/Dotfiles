-- OPTIONS - CONFIGURACIÓN OPTIMIZADA PARA RENDIMIENTO

local opt = vim.opt

---------------------------------------------------------
-- NEOVIDE (GUI)
---------------------------------------------------------
if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font:h13"
    vim.g.neovide_cursor_animation_length = 0.08  -- Reducido para mejor rendimiento
    vim.g.neovide_cursor_trail_size = 0.6
    vim.g.neovide_cursor_vfx_mode = "railgun"
end

---------------------------------------------------------
-- INTERFAZ BÁSICA
---------------------------------------------------------
opt.number = true
opt.relativenumber = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.undofile = true
opt.confirm = true

---------------------------------------------------------
-- RENDIMIENTO 🚀
---------------------------------------------------------
opt.updatetime = 300         -- Refresco de diagnósticos (ms) - Óptimo para multi-lenguaje
opt.timeoutlen = 400         -- Tiempo para keymaps (ms) - Responsivo
opt.lazyredraw = true        -- 🚀 Evita redraws innecesarios
opt.synmaxcol = 300          -- 🚀 Resaltado de sintaxis hasta columna 300 (aumentado para líneas largas)
opt.ttyfast = true           -- 🚀 Asume conexión rápida a terminal
-- opt.regexpengine = 1      -- 🚫 Desactivado: el motor OLD es más lento en JSX/TSX
opt.redrawtime = 5000        -- Timeout para redraw en ms (evita bloqueos)
opt.shada = { "!", "'1000", "<50", "s10", "h" } -- Mejora persistencia eficiente

---------------------------------------------------------
-- DISPLAY Y NAVEGACIÓN
---------------------------------------------------------
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 10
opt.splitright = true
opt.splitbelow = true

---------------------------------------------------------
-- INDENTACIÓN
---------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

---------------------------------------------------------
-- BÚSQUEDA
---------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true