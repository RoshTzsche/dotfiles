#!/usr/bin/env bash
SHADER_PATH="$HOME/.config/hypr/shaders/grayscale.glsl"
CURRENT_SHADER=$(hyprctl getoption decoration:screen_shader -j | jq -r '.str')

if [[ "$CURRENT_SHADER" == *grayscale.glsl* ]]; then
    # --- DISABLE READING MODE ---
    hyprctl keyword decoration:screen_shader "[[EMPTY]]"
    hyprctl keyword animations:enabled 1
    hyprctl keyword decoration:drop_shadow 1
    hyprctl keyword decoration:blur:enabled 1
    hyprctl keyword decoration:rounding 1 
    

else
    # --- ENABLE READING MODE ---
    hyprctl keyword decoration:screen_shader "$SHADER_PATH"
    hyprctl keyword decoration:drop_shadow 0
    hyprctl keyword decoration:blur:enabled 0
    hyprctl keyword decoration:rounding 0 
    
fi
