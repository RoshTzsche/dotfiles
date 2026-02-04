#!/bin/bash

# --- CONFIGURACIÓN ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers" 
STATE_FILE="$HOME/.last_wallpaper"

# 1. Lógica de Selección (Idéntica a tu lógica, funciona bien)
if [ -z "$1" ]; then
    LAST_WALLPAPER=$(cat "$STATE_FILE" 2>/dev/null)
    # Usamos mapfile para arrays más seguros en bash
    mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | sort)

    CURRENT_INDEX=-1
    for i in "${!WALLPAPERS[@]}"; do
        if [[ "${WALLPAPERS[$i]}" == "$LAST_WALLPAPER" ]]; then
            CURRENT_INDEX=$i
            break
        fi
    done

    NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#WALLPAPERS[@]} ))
    WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"
    echo "$WALLPAPER" > "$STATE_FILE"
else
    WALLPAPER="$1"
fi

if [ -f "$WALLPAPER" ]; then
    ABSOLUTE_WALLPAPER=$(realpath "$WALLPAPER")
    
    # 2. Gestión del Daemon Hyprpaper
    if ! pgrep -x "hyprpaper" > /dev/null; then
        hyprpaper &
        sleep 1 # Dar tiempo al socket para despertar
    fi

    # 3. Preload (Carga en VRAM)
    hyprctl hyprpaper preload "$ABSOLUTE_WALLPAPER"

    # 4. Aplicación por Monitor
    # Detectamos monitores activos para tu configuración híbrida
    # eDP-1 (Tu pantalla 16:10) y externos si los hubiera
    for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
        hyprctl hyprpaper wallpaper "$monitor,$ABSOLUTE_WALLPAPER"
    done

    # 5. LIMPIEZA DE VRAM (CRÍTICO PARA TU RYZEN)
    # Descargamos el wallpaper anterior de la memoria si es diferente al actual
    if [ ! -z "$LAST_WALLPAPER" ] && [ "$LAST_WALLPAPER" != "$ABSOLUTE_WALLPAPER" ]; then
         LAST_ABSOLUTE=$(realpath "$LAST_WALLPAPER")
         hyprctl hyprpaper unload "$LAST_ABSOLUTE"
    fi

    # 6. Generación de Colores (Pywal)
    # -n: No intenta cambiar el fondo (ya lo hizo hyprpaper)
    # -s: Salta la generación de esquemas para terminales (si usas cache de kitty directo)
    # -t: Salta la aplicación en tty
    wal -i "$ABSOLUTE_WALLPAPER" -n -q

    # 7. Recarga de Interfaz
    # Usamos señales (SIGUSR2) en lugar de matar el proceso si es posible, 
    # pero para cambiar colores en Waybar, el reinicio suele ser necesario para leer el CSS nuevo.
    
    # Actualizar Kitty al instante (socket)
    killall -SIGUSR1 kitty

    # Reiniciar Waybar suavemente
    pkill waybar
    # Esperamos que muera para evitar condiciones de carrera
    while pgrep -x waybar >/dev/null; do sleep 0.1; done
    waybar & disown

    # Notificación (Opcional, requiere libnotify)
    notify-send "Estética Actualizada" "Wallpaper: $(basename "$WALLPAPER")" -i "$ABSOLUTE_WALLPAPER"

else
    echo "Error: Archivo no encontrado: $WALLPAPER"
fi

#sleep 1
#Script de color de teclado
$HOME/Scripts/keyboardcolor.sh &
