#!/bin/bash
# -----------------------------------------------------------------------------
# Info: Screenshot Wrapper for Hyprland (Grim + Slurp + Swappy)
# Dependencies: grim, slurp, wl-clipboard, swappy, libnotify, jq
# -----------------------------------------------------------------------------

DIR="$HOME/Pictures/Screenshots"
NAME="screenshot_$(date +%Y%m%d_%H%M%S).png"

# Ensure the directory exists
mkdir -p "$DIR"

option=$1

case $option in
    "s") 
        # Select region -> Edit in Swappy -> Save/Copy automatically from Swappy
        # Note: Swappy config usually handles the final save location
        grim -g "$(slurp)" - | swappy -f -
        ;;
    "p") 
        # Full Screen -> Save to disk directly
        grim "$DIR/$NAME"
        notify-send "Screenshot Created" "Saved to $DIR/$NAME" -i "$DIR/$NAME"
        ;;
    "sf") 
        # Frozen Selection -> Copy to Clipboard only (No editor)
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot" "Region copied to clipboard"
        ;;
    "m") 
        # Current Monitor -> Save to disk
        # Uses jq to detect the currently focused monitor
        MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
        grim -o "$MONITOR" "$DIR/$NAME"
        notify-send "Monitor Screenshot" "Saved to $DIR/$NAME"
        ;;
    *)
        echo "Usage: $0 {s|p|sf|m}"
        echo "  s  - Select region and edit (Swappy)"
        echo "  p  - Fullscreen (Save to disk)"
        echo "  sf - Select region (Clipboard only)"
        echo "  m  - Current Monitor (Save to disk)"
        exit 1
        ;;
esac
