# 🚀 QUICK START GUIDE - NEOVIM 2026

Tu configuración Neovim está ahora **optimizada para máximo rendimiento** en 2026.

## ⚡ INSTALACIÓN RÁPIDA

### 1️⃣ Instalar Formatters (CRÍTICO para format-on-save)

```bash
# Opción A: Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y npm python3-pip
npm install -g prettier
pip install black isort
# Para Lua (opcional, requiere Rust)
cargo install stylua 2>/dev/null || echo "Skipping stylua - install Rust if needed"

# Opción B: macOS (Homebrew)
brew install prettier black stylua npm

# Opción C: Fedora/RHEL
sudo dnf install npm
npm install -g prettier
pip install black isort
```

### 2️⃣ Iniciar Neovim
```bash
nvim
# Mason instalará automáticamente todos los Language Servers
# Espera a que termine (verás mensajes en la pantalla)
```

### 3️⃣ Verificar todo funciona
```bash
# Dentro de Neovim:
:MasonStatus      # Ver Language Servers instalados
:ConformInfo      # Ver Formatters disponibles
:checkhealth      # Health check general
```

---

## 📋 KEYMAPS PRINCIPALES (VSCode-Style)

### 🔍 Búsqueda & Navegación
| Atajo | Función |
|-------|---------|
| `Ctrl+p` | Buscar archivos |
| `Ctrl+Shift+f` | Buscar texto en proyecto |
| `Ctrl+f` | Buscar en archivo actual |
| `Ctrl+b` | Toggle file explorer |

### 🛠️ Edición
| Atajo | Función |
|-------|---------|
| `Ctrl+s` | Guardar (auto-format) |
| `Ctrl+z` | Deshacer |
| `Ctrl+Shift+z` | Rehacer |
| `Ctrl+c` | Copiar |
| `Ctrl+x` | Cortar |
| `Ctrl+v` | Pegar |
| `Ctrl+/` | Comentar/Descomentar |

### 🧠 Programación (LSP)
| Atajo | Función |
|-------|---------|
| `K` | Ver documentación |
| `gd` | Ir a definición |
| `gr` | Ver referencias |
| `gi` | Ir a implementación |
| `Space+rn` | Renombrar variable |
| `Space+ca` | Code actions |
| `Space+f` | Formatear código |

### 💻 Multi-cursor (VSCode-style)
| Atajo | Función |
|-------|---------|
| `Ctrl+d` | Seleccionar palabra siguiente |
| `Ctrl+Shift+l` | Seleccionar todas las instancias |

---

## 🎨 CARACTERÍSTICAS PRINCIPALES

✅ **LSP Integrado** - 9 language servers auto-instalados:
   - Lua, Python, JavaScript/TypeScript, Bash, YAML, JSON, HTML, CSS, ESLint

✅ **Autocompleción Inteligente** - Completado desde:
   - LSP (prioridad máxima)
   - Snippets (VSCode-compatible)
   - Buffer actual
   - Rutas de archivos

✅ **Formatting Automático** - Al guardar:
   - Limpia espacios en blanco
   - Crea carpetas si no existen
   - Formatea con prettier/black/stylua
   - Con LSP fallback si formatter no disponible

✅ **Git Integration** - Con gitsigns:
   - Indicadores de líneas modificadas
   - Información del branch en status bar

✅ **Syntax Highlighting** - Con Treesitter:
   - Resaltado preciso y rápido
   - 9 lenguajes soportados

✅ **Multi-cursor** - Estilo VSCode:
   - `Ctrl+d` para multi-selección
   - `Ctrl+Shift+l` para todas instancias

---

## ⚙️ CONFIGURACIÓN OPTIMIZADA PARA 2026

### 🚀 Performance Settings
- `updatetime: 300ms` - Diagnósticos rápidos
- `synmaxcol: 300` - Resaltado hasta columna 300
- `lazyredraw: true` - Redraws eficientes
- `lazy loading: automático` - Solo carga plugins cuando se necesita

### 🔧 Lazy Loading (Optimización)
- **LSP, Treesitter, Cmp**: Se cargan al abrir archivos
- **Conform**: Se carga al guardar (BufWritePre)
- **Telescipe**: Se carga al usar keymaps
- **Neo-tree**: Siempre cargado (file explorer crítico)

### 📦 Plugin Manager: lazy.nvim
- Auto-importa plugins de `lua/plugins/`
- Gestión eficiente de dependencias
- Snapshots en `lazy-lock.json`

---

## 📊 ESTRUCTURA DEL PROYECTO

```
~/.config/nvim/
├── init.lua                  # Punto de entrada (4 líneas)
├── lazy-lock.json           # Snapshots de plugins
├── DEPENDENCIES.md          # Lista de dependencias
├── QUICK_START.md           # Este archivo
└── lua/
    ├── config/
    │   ├── lazy.lua         # Configuración del plugin manager
    │   ├── options.lua      # Opciones del editor (optimizadas)
    │   ├── keymaps.lua      # Todos los atajos (138 líneas)
    │   └── autocmds.lua     # Auto-comandos (highlight, cleanup, etc)
    └── plugins/             # Configuración individual de 29 plugins
        ├── lsp.lua          # Language servers
        ├── cmp.lua          # Autocompleción
        ├── conform.lua      # Formatters (format on save)
        ├── treesitter.lua   # Syntax highlighting
        ├── telescope.lua    # Búsqueda fuzzy
        ├── neo-tree.lua     # File explorer
        ├── ... etc ...
        └── editorconfig.lua # NEW: EditorConfig support
```

---

## 🐛 TROUBLESHOOTING

### "Formatter no funciona"
```bash
# 1. Verificar si está instalado
which prettier  # o 'which black', 'which stylua'

# 2. Si no está, instalar desde PASO 1
# 3. Dentro de Neovim:
:ConformInfo
```

### "LSP no funciona"
```bash
# Dentro de Neovim:
:MasonStatus        # Ver qué está instalado
:LspInfo            # Info del LSP actual
:checkhealth nvim   # Diagnóstico completo
```

### "Startup lento"
```bash
# Medir startup time:
nvim --startuptime startup.log
# Ver qué plugins tardan más (verlo después de cerrar Neovim)
tail -20 startup.log

# Si algún plugin es lento, puede tener lazy loading incorrecto
# Revisar lua/plugins/NOMBRE_PLUGIN.lua y agregar 'event' o 'keys'
```

---

## 🎯 MEJORAS EN ESTA VERSIÓN

✅ **Resueltos conflictos de formatting** - Centralizado en conform.lua
✅ **Removidas duplicaciones de keymaps** - LSP keymaps ahora solo en lsp.lua
✅ **Optimizado para multi-lenguaje** - `synmaxcol: 300`, mejor regex engine
✅ **Lazy loading mejorado** - Bufferline y multicursor ahora VeryLazy
✅ **EditorConfig agregado** - Para consistency cross-project
✅ **Documentación completa** - DEPENDENCIES.md y este archivo

---

## 🔗 REFERENCIAS

- [Lazy.nvim Docs](https://github.com/folke/lazy.nvim)
- [Neovim Docs](https://neovim.io/doc/)
- [LSPConfig Servers](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
- [Conform Formatters](https://github.com/stevearc/conform.nvim)

---

**¿Problemas?** Revisa `.config/nvim/lua/` o ejecuta `:checkhealth` en Neovim.

**¡Disfruta editando! 🎉**
