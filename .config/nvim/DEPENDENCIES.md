# 📦 DEPENDENCIAS NECESARIAS PARA NEOVIM

Esta configuración de Neovim requiere varias herramientas externas para funcionar completamente.

## 🔧 FORMATTERS (Requeridos para format-on-save)

### Lua
```bash
cargo install stylua  # O: sudo luarocks install stylua
```

### Python
```bash
pip install black isort
```

### JavaScript/TypeScript/JSON/YAML/HTML/CSS/Markdown
```bash
npm install -g prettier
```

## 📊 INSTALACIÓN RÁPIDA

### En Ubuntu/Debian:
```bash
# Instalar formatters
sudo apt-get install -y npm
npm install -g prettier

pip install black isort

cargo install stylua  # Si tienes Rust instalado
```

### En macOS (con Homebrew):
```bash
brew install prettier
brew install black
brew install stylua
```

### En Fedora/RHEL:
```bash
dnf install npm
npm install -g prettier
pip install black isort
cargo install stylua
```

## ✅ VERIFICAR INSTALACIÓN

```bash
# Verificar que están disponibles
which prettier
which black
which isort
which stylua

# O desde Neovim
:ConformInfo
```

## 🚀 LANGUAGE SERVERS

Los Language Servers se instalan **automáticamente** con Mason al iniciar Neovim:
- `lua_ls` (Lua)
- `pyright` (Python)
- `bashls` (Bash)
- `yamlls` (YAML)
- `jsonls` (JSON)
- `ts_ls` (TypeScript/JavaScript)
- `html` (HTML)
- `cssls` (CSS)
- `eslint` (JavaScript linting)

### Verificar instalación de LSPs:
```bash
:MasonStatus
```

## 📝 NOTAS IMPORTANTES

- Si un formatter no está instalado, conform.nvim usará LSP fallback
- Los formatters deben estar en tu PATH
- Algunos formatters pueden requerir herramientas de construcción
