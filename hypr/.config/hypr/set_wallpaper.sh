#!/bin/bash

# --- CONFIGURATION ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers" 
STATE_FILE="$HOME/.last_wallpaper"

# 1. Selection Logic 
if [ -z "$1" ]; then
    LAST_WALLPAPER=$(cat "$STATE_FILE" 2>/dev/null)
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
    
    # 2. Hyprpaper Daemon Management
    if ! pgrep -x "hyprpaper" > /dev/null; then
        hyprpaper &
        sleep 1 # Give the socket time to wake up
    fi

    # 3. Preload (Load into VRAM)
    hyprctl hyprpaper preload "$ABSOLUTE_WALLPAPER"

    # 4. Apply per Monitor
    # Detect active monitors for hybrid configuration
    for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
        hyprctl hyprpaper wallpaper "$monitor,$ABSOLUTE_WALLPAPER"
    done

    # 5. VRAM CLEANUP
    if [ ! -z "$LAST_WALLPAPER" ] && [ "$LAST_WALLPAPER" != "$ABSOLUTE_WALLPAPER" ]; then
         LAST_ABSOLUTE=$(realpath "$LAST_WALLPAPER")
         hyprctl hyprpaper unload "$LAST_ABSOLUTE"
    fi

    # 6. Color Generation (Pywal)
    # -n: Do not attempt to change the background (hyprpaper already did it)
    # -s: Skip terminal scheme generation (if using direct kitty cache)
    # -t: Skip tty application
    wal -i "$ABSOLUTE_WALLPAPER" -n -q

    # 7. Interface Reload
    # Use signals (SIGUSR2) instead of killing the process if possible, 
    # but for Waybar color changes, a restart is usually needed to read the new CSS.
    
    # Update Kitty instantly (socket)
    killall -SIGUSR1 kitty

    # Restart Waybar gently
    pkill waybar
    # Wait for it to die to avoid race conditions
    while pgrep -x waybar >/dev/null; do sleep 0.1; done
    waybar & disown

    # Notification (Optional, requires libnotify)
    notify-send "Aesthetics Updated" "Wallpaper: $(basename "$WALLPAPER")" -i "$ABSOLUTE_WALLPAPER"

else
    echo "Error: File not found: $WALLPAPER"
fi

#sleep 1
# Keyboard color script
$HOME/Scripts/keyboardcolor.sh &
