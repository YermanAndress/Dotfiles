local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Resaltar al copiar
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function() vim.highlight.on_yank() end,
})

-- Ajustes de guardado: Limpieza + Creación de directorios
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("clean_on_save"),
  callback = function(event)
    -- 1. Limpiar espacios al final
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)

    -- 2. Crear carpetas si no existen
    local dir = vim.fn.fnamemodify(event.match, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
    
    -- 3. Formateo automático (Conform)
    -- require("conform").format({ bufnr = event.buf, lsp_fallback = true })
    -- Comentado para evitar errores si no tienes el plugin conform.nvim
  end,
})

-- Recordar última posición del cursor
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Cerrar ventanas de ayuda/logs con 'q'
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Integración automática de neo-tree al abrir Neovim en un directorio
-- Detecta si se abre un directorio y carga neo-tree en lugar de netrw
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("auto_neotree"),
  callback = function()
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) == 1 then
        vim.cmd("Neotree")
      end
    end
  end,
})