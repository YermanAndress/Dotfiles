#!/bin/bash
# by discomanfulanito & Gemini optimized

POKEMON_LIST=("mimikyu" "gengar")
FETCHER="fastfetch"

# 1. Validaciones rápidas
command -v pokeget >/dev/null || { echo "❌ pokeget no instalado"; exit 1; }
command -v $FETCHER >/dev/null || { echo "❌ $FETCHER no instalado"; exit 1; }

# 2. Selección con tu lógica de índice 1
INDICE=$(( RANDOM % ${#POKEMON_LIST[@]} + 1))
pokemon="${POKEMON_LIST[$INDICE]}"

#echo "DEBUG: Total: $TOTAL | Índice: $INDICE | Pokemon: $pokemon"

sprite=$(pokeget "$pokemon" --hide-name 2>/dev/null)

# 3. Mediciones reales
FETCHER_LINES=$((($($FETCHER --pipe | wc -l) + 1) / 2)) 
SPRITE_HEIGHT=$(echo "$sprite" | wc -l)

# 4. Cálculos de Padding
# Centrado vertical
PAD_TOP=$(( (FETCHER_LINES - SPRITE_HEIGHT) / 2 ))
[[ $PAD_TOP -lt 0 ]] && PAD_TOP=0

# Padding lateral (Ajusta este valor si el texto choca con el Pokémon)
# Un valor de 4 a 8 suele ser ideal para pokeget
PAD_LAT=4

# 5. EJECUCIÓN FINAL con corrección de Wrap
echo "$sprite" | $FETCHER \
    --file-raw - \
    --logo-padding-top $PAD_TOP \
    --logo-padding-left $PAD_LAT \
    --logo-padding-right $PAD_LAT \
    --disable-linewrap true