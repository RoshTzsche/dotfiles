#!/usr/bin/env bash

ROFI_CONF="$HOME/.config/rofi/config.rasi"

selected=$(rofi \
    -show drun \
    -theme "$ROFI_CONF" \
    -drun-print-desktop \
    -print-to-stdout)
    
exit_code=$?
if [ $exit_code -eq 0 ]; then
    if [[ "$selected" == *.desktop ]]; then
        app_id=$(basename "$selected" .desktop)
        exit 0
    fi
    
    if [[ "$selected" != "" ]]; then
         xdg-open "https://www.google.com/search?q=${selected}" > /dev/null 2>&1 &
    fi
fi
