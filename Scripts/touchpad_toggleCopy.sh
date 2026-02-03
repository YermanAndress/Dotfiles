#!/bin/bash

DEVICE="asue1301:00-04f3:3128-touchpad"
STATE_FILE="/tmp/touchpad_status"

# Si el archivo no existe, lo creamos asumiendo que está encendido (1)
if [ ! -f "$STATE_FILE" ]; then
    echo "1" > "$STATE_FILE"
fi

STATUS=$(cat "$STATE_FILE")

if [ "$STATUS" -eq 1 ]; then
    # Si está en 1, lo apagamos
    hyprctl keyword "device[$DEVICE]:enabled" false
    echo "0" > "$STATE_FILE"
    notify-send -u low -t 1500 "Touchpad" "Desactivado 󰟙"
else
    # Si está en 0, lo encendemos
    hyprctl keyword "device[$DEVICE]:enabled" true
    echo "1" > "$STATE_FILE"
    notify-send -u low -t 1500 "Touchpad" "Activado 󰟜"
fi
