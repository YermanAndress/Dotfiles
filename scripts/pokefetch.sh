#!/usr/bin/zsh
# Optimized for Wayland/Kitty Speed

POKEMON_LIST=("mimikyu" "gengar")
FETCHER="fastfetch"

# 1. Selección aleatoria instantánea (Zsh index)
pokemon=$POKEMON_LIST[$(( (RANDOM % $#POKEMON_LIST) + 1 ))]

# 2. Captura del sprite (Única llamada externa pesada necesaria)
sprite=$(pokeget "$pokemon" --hide-name 2>/dev/null)

# 3. Cálculos de altura usando Zsh (0ms de coste)
# Dividimos el sprite en un array de líneas para contar su longitud
sprite_lines=("${(f)sprite}")
SPRITE_HEIGHT=$#sprite_lines

# Fastfetch suele tener unas 15-18 líneas fijas. 
# Evitamos ejecutar 'fastfetch --pipe | wc' en cada apertura.
FETCHER_LINES=16 

# 4. Cálculo de Padding Vertical
PAD_TOP=$(( (FETCHER_LINES - SPRITE_HEIGHT) / 2 ))
(( PAD_TOP < 0 )) && PAD_TOP=0

# 5. EJECUCIÓN FINAL
# Usamos '<<< $sprite' para evitar un pipe extra
$FETCHER \
    --file-raw - \
    --logo-padding-top $PAD_TOP \
    --logo-padding-left 4 \
    --logo-padding-right 4 \
    --disable-linewrap true <<< "$sprite"