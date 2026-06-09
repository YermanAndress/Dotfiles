return {
  'mg979/vim-visual-multi',
  branch = 'master',
  event = "VeryLazy",  -- 🚀 Se carga después de plugins críticos
  init = function()
    -- Desactivar mapas por defecto para usar los de VS Code
    vim.g.VM_default_mappings = 0
    vim.g.VM_maps = {
      ['Find Under'] = '<C-d>',    -- Ctrl + d selecciona palabra
      ['Find Next'] = '<C-d>',     -- Ctrl + d selecciona la siguiente
      ['Select All'] = '<C-S-l>',  -- Ctrl + Shift + l selecciona todas
    }
  end,
}