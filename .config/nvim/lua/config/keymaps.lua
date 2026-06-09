--------------------------------------------------------------
-- GUÍA RÁPIDA DE MODOS Y PREFIJOS
--------------------------------------------------------------
-- n: Modo Normal (Navegación y comandos)
-- i: Modo Insertar (Escritura de texto)
-- v: Modo Visual (Selección de texto)
-- <leader>: Tecla especial (Espacio en tu caso) para atajos personalizados
-- <C-...>: Tecla Control
-- <A-...>: Tecla Alt
-- <S-...>: Tecla Alt (Shift)
-- <BS>: Backspace (Borrar)
--------------------------------------------------------------

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " " -- Barra espaciadora como líder

--------------------------------------------------------------
-- 1. EDICIÓN DE TEXTO Y PORTAPAPELES
--------------------------------------------------------------

-- Copiar, Cortar y Pegar (Estilo VSCode)
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copiar al portapapeles del sistema" })
map("v", "<C-x>", '"+x', { desc = "Cortar al portapapeles del sistema" })
map("n", "<C-v>", '"+p', { desc = "Pegar en modo Normal" })
map("i", "<C-v>", '<Esc>"+pa', { desc = "Pegar en modo Insertar" })

-- Borrado rápido
map("i", "<C-BS>", "<C-w>", { desc = "Borrar palabra hacia atrás (Ctrl + Backspace)" })
map("i", "<C-H>", "<C-w>", { desc = "Compatibilidad para algunas terminales" })

-- Deshacer y Rehacer
map("n", "<C-z>", "u", { desc = "Deshacer" })
map("n", "<C-S-z>", "<C-r>", { desc = "Rehacer (Ctrl + Shift + Z)" })

-- Seleccionar todo
map("n", "<C-a>", "mgggVG", { desc = "Selecciona todo manteniendo una marca de posición" })
map("i", "<C-a>", "mgggVG", { desc = "Selecciona todo manteniendo una marca de posición" })

-- Comentarios (Usa Comment.nvim)
map("i", "<C-/>", "gcc", { remap = true, silent = true, desc = "Comentar línea en modo Insertar" })
map("n", "<C-/>", "gcc", { remap = true, silent = true, desc = "Comentar línea en modo Normal" })
map("v", "<C-/>", "gc", { remap = true, silent = true, desc = "Comentar/Descomentar selección" })

--------------------------------------------------------------
-- 2. MOVIMIENTO Y SELECCIÓN INTELIGENTE
--------------------------------------------------------------

-- Seleccionar palabra por palabra (Ctrl + Shift + Flechas)
-- Modo Normal
map("n", "<C-S-Right>", "vwb", { desc = "Seleccionar palabra hacia adelante" })
map("n", "<C-S-Left>", "vb", { desc = "Seleccionar palabra hacia atrás" })
-- Modo Visual (Extender selección)
map("v", "<C-S-Right>", "w", { desc = "Extender selección hacia adelante" })
map("v", "<C-S-Left>", "b", { desc = "Extender selección hacia atrás" })
-- Modo Insertar
map("i", "<C-S-Right>", "<Esc>vwa", { desc = "Seleccionar palabra hacia adelante en Insert" })
map("i", "<C-S-Left>", "<Esc>vba", { desc = "Seleccionar palabra hacia atrás en Insert" })

-- Mover líneas arriba/abajo (Alt + Flechas)
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Mover línea hacia arriba" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Mover línea hacia abajo" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover bloque hacia arriba" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover bloque hacia abajo" })

--------------------------------------------------------------
-- 3. GESTIÓN DE VENTANAS Y BUFFERS
--------------------------------------------------------------

-- Navegación entre Ventanas (Ctrl + hjkl)
map("n", "<C-j>", "<C-w>h", { desc = "Ir a ventana izquierda" })
map("n", "<C-k>", "<C-w>j", { desc = "Ir a ventana abajo" })
map("n", "<C-i>", "<C-w>k", { desc = "Ir a ventana arriba" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir a ventana derecha" })

-- Cambiar tamaño de Ventanas (Alt + flechas simbólicas)
map("n", "<A-<>", ":vertical resize -5<CR>", { desc = "Reducir ancho de ventana" })
map("n", "<A->>", ":vertical resize +5<CR>", { desc = "Aumentar ancho de ventana" })
map("n", "<A-+>", ":resize +3<CR>", { desc = "Aumentar alto de ventana" })
map("n", "<A-_>", ":resize -3<CR>", { desc = "Reducir alto de ventana" })

-- Navegación de Pestañas/Buffers (Ctrl + Tab)
map("n", "<C-Tab>", ":bn<CR>", { desc = "Ir al siguiente buffer" })
map("n", "<C-S-Tab>", ":bprevious<CR>", { desc = "Ir al buffer anterior" })

-- Archivo y Buffer
map("n", "<C-s>", ":w<CR>", { desc = "Guardar archivo" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Guardar desde modo insertar" })
map("n", "<C-w>", ":bd<CR>", { desc = "Cerrar buffer actual" })

--------------------------------------------------------------
-- 4. PLUGINS (Neo-tree, Fzf-lua, VM)
--------------------------------------------------------------

-- Explorador de archivos (Neo-tree)
map("n", "<C-b>", ":Neotree toggle<CR>", { desc = "Toggle explorador (sidebar)" })
map("n", "<leader>e", ":Neotree focus<CR>", { desc = "Enfocar explorador de archivos" })

-- Búsqueda (Fzf-lua)
map("n", "<C-p>", ":FzfLua files<CR>", { desc = "Buscar archivos por nombre" })
map("n", "<C-S-p>", ":FzfLua commands<CR>", { desc = "Mostrar comandos de Neovim" })
map("n", "<C-f>", ":FzfLua buffers<CR>", { desc = "Buscar en buffers abiertos" })
map("n", "<C-S-f>", ":FzfLua live_grep<CR>", { desc = "Buscar texto en todo el proyecto" })
map("n", "<leader>gs", ":FzfLua git_status<CR>", { desc = "Mostrar estado de git" })

-- Multi-cursores (vim-visual-multi)
map("n", "<C-d>", ":VM-Find-Under<CR>", { desc = "Seleccionar siguiente coincidencia" })
map("v", "<C-d>", ":VM-Find-Under<CR>", { desc = "Seleccionar siguiente coincidencia en Visual" })

--------------------------------------------------------------
-- 5. LSP e INTELIGENCIA (Programación)
--------------------------------------------------------------

-- 🚀 LSP Keymaps están centralizados en plugins/lsp.lua (LspAttach autocmd)
-- Esto evita duplicación y asegura que solo se activen cuando hay LSP disponible
map("n", "<leader>f", function() require("conform").format({ async = true }) end, { desc = "Formatear código" })

-- Navegación Treesitter (Saltar entre funciones/clases)
map("n", "]f", "<cmd>TSNextFunction<CR>", { desc = "Saltar a la siguiente función" })
map("n", "[f", "<cmd>TSPrevFunction<CR>", { desc = "Saltar a la función anterior" })

--------------------------------------------------------------
-- 6. UTILIDADES DE SISTEMA
--------------------------------------------------------------

map("n", "<Esc>", ":noh<CR>", { desc = "Quitar el resaltado de búsqueda" })
map("n", "<leader>qq", ":q!<CR>", { desc = "Salir sin guardar de golpe" })
map("n", "<leader>ww", ":w<CR>", { desc = "Guardado rápido con espacio-w" })