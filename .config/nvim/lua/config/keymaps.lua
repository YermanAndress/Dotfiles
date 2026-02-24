--------------------------------------------------------------
-- GUÍA RÁPIDA DE MODOS Y PREFIJOS
--------------------------------------------------------------
-- n: Modo Normal (Navegación y comandos)
-- i: Modo Insertar (Escritura de texto)
-- v: Modo Visual (Selección de texto)
-- <leader>: Tecla especial (Espacio en tu caso) para atajos personalizados
-- <C-...>: Tecla Control
-- <A-...>: Tecla Alt
-- <S-...>: Tecla Shift (Mayús)
-- <BS>: Backspace (Borrar)
--------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " " -- Barra espaciadora como líder

--------------------------------------------------------------
-- 1. EDICIÓN DE TEXTO Y PORTAPAPELES
--------------------------------------------------------------

-- Copiar, Cortar y Pegar (Estilo VSCode)
map({ "n", "v" }, "<C-c>", '"+y', opts)       -- Copiar al portapapeles del sistema
map("v", "<C-x>", '"+x', opts)                -- Cortar al portapapeles del sistema
map("n", "<C-v>", '"+p', opts)                -- Pegar en modo Normal
map("i", "<C-v>", '<Esc>"+pa', opts)          -- Pegar en modo Insertar

-- Borrado rápido
map("i", "<C-BS>", "<C-w>", opts)             -- Borrar palabra hacia atrás (Ctrl + Backspace)
map("i", "<C-H>", "<C-w>", opts)              -- Compatibilidad para algunas terminales

-- Deshacer y Rehacer
map("n", "<C-z>", "u", opts)
map("n", "<C-S-z>", "<C-r>", opts)            -- Ctrl + Shift + Z

-- Seleccionar todo
map("n", "<C-a>", "mgggVG", opts)             -- Selecciona todo manteniendo una marca de posición
map("i", "<C-a>", "mgggVG", opts)             -- Selecciona todo manteniendo una marca de posición


-- Comentarios (Usa Comment.nvim)
map("i", "<C-/>", "gcc", { remap = true, silent = true })
map("n", "<C-/>", "gcc", { remap = true, silent = true })
map("v", "<C-/>", "gc", { remap = true, silent = true })

--------------------------------------------------------------
-- 2. MOVIMIENTO Y SELECCIÓN INTELIGENTE
--------------------------------------------------------------

-- Seleccionar palabra por palabra (Ctrl + Shift + Flechas)
-- Modo Normal
map("n", "<C-S-Right>", "vwb", opts)
map("n", "<C-S-Left>", "vb", opts)
-- Modo Visual (Extender selección)
map("v", "<C-S-Right>", "w", opts)
map("v", "<C-S-Left>", "b", opts)
-- Modo Insertar
map("i", "<C-S-Right>", "<Esc>vwa", opts)
map("i", "<C-S-Left>", "<Esc>vba", opts)

-- Mover líneas arriba/abajo (Alt + Flechas)
map("n", "<A-Up>", ":m .-2<CR>==", opts)
map("n", "<A-Down>", ":m .+1<CR>==", opts)
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)

--------------------------------------------------------------
-- 3. GESTIÓN DE VENTANAS Y BUFFERS
--------------------------------------------------------------

-- Navegación entre Ventanas (Ctrl + hjkl)
map("n", "<C-j>", "<C-w>h", opts) -- Ventana Izquierda
map("n", "<C-k>", "<C-w>j", opts) -- Ventana Abajo
map("n", "<C-i>", "<C-w>k", opts) -- Ventana Arriba
map("n", "<C-l>", "<C-w>l", opts) -- Ventana Derecha

-- Cambiar tamaño de Ventanas (Alt + flechas simbólicas)
map("n", "<A-<>", ":vertical resize -5<CR>", opts)
map("n", "<A->>", ":vertical resize +5<CR>", opts)
map("n", "<A-+>", ":resize +3<CR>", opts)
map("n", "<A-_>", ":resize -3<CR>", opts)

-- Navegación de Pestañas/Buffers (Ctrl + Tab)
map("n", "<C-Tab>", ":bn<CR>", opts)
map("n", "<C-S-Tab>", ":bprevious<CR>", opts)

-- Archivo y Buffer
map("n", "<C-s>", ":w<CR>", opts)             -- Guardar
map("i", "<C-s>", "<Esc>:w<CR>a", opts)       -- Guardar desde modo insertar
map("n", "<C-w>", ":bd<CR>", opts)            -- Cerrar pestaña actual (Buffer)

--------------------------------------------------------------
-- 4. PLUGINS (Telescope, Neo-tree, VM)
--------------------------------------------------------------

-- Explorador de archivos (Neo-tree)
map("n", "<C-b>", ":Neotree toggle<CR>", opts)
map("n", "<leader>e", ":Neotree focus<CR>", opts)


-- Búsqueda (Telescope) - NOTA: Los keybindings principales ahora están en telescope.lua con lazy loading
map("n", "<C-p>", ":Telescope find_files<CR>", opts)                    -- Buscar archivos por nombre
map("n", "<C-S-p>", ":Telescope commands<CR>", opts)                    -- Comandos de Neovim
map("n", "<C-f>", ":Telescope current_buffer_fuzzy_find<CR>", opts)     -- Buscar en archivo actual
map("n", "<C-S-f>", ":Telescope live_grep<CR>", opts)                   -- Buscar texto en todo el proyecto
map("n", "<leader>gs", ":Telescope git_status<CR>", opts)

-- Multi-cursores (vim-visual-multi)
map("n", "<C-d>", ":VM-Find-Under<CR>", opts)                           -- Seleccionar siguiente coincidencia
map("v", "<C-d>", ":VM-Find-Under<CR>", opts)

--------------------------------------------------------------
-- 5. LSP e INTELIGENCIA (Programación)
--------------------------------------------------------------

-- Navegación de código
map("n", "K", vim.lsp.buf.hover, opts)           -- Ver documentación
map("n", "gd", vim.lsp.buf.definition, opts)    -- Ir a definición
map("n", "gi", vim.lsp.buf.implementation, opts) -- Ir a implementación
map("n", "gr", vim.lsp.buf.references, opts)     -- Ver donde se usa

-- Acciones de código
map("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Renombrar variable/función
map("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Sugerencias de corrección
map("n", "<leader>f", function() require("conform").format({ async = true }) end, opts) -- Formatear código

-- Navegación Treesitter (Saltar entre funciones/clases)
map("n", "]f", "<cmd>TSNextFunction<CR>", opts)
map("n", "[f", "<cmd>TSPrevFunction<CR>", opts)

--------------------------------------------------------------
-- 6. UTILIDADES DE SISTEMA
--------------------------------------------------------------

map("n", "<Esc>", ":noh<CR>", opts)   -- Quitar el resaltado de búsqueda
map("n", "<leader>qq", ":q!<CR>", opts) -- Salir sin guardar de golpe
map("n", "<leader>ww", ":w<CR>", opts)  -- Guardado rápido con espacio-w