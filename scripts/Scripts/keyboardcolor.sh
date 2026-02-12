#!/bin/bash
# Import palette from pywal
source "$HOME/.cache/wal/colors.sh"

# Note: Ensure "NOMBRE" matches your device name in openrgb --list-devices
lenovo=$(openrgb --list-devices | grep -i "NOMBRE" | head -n 1 | awk -F ':' '{print $1}')

logitech=$(openrgb --list-devices | grep -i "NOMBRE" | head -n 1 | awk -F ':' '{print $1}')


openrgb --device lenovo \
	--color ${color1:1},${color2:1},${color3:1},${color4:1} \
	--mode static --brightness 100 --speed 1

# Mode can be changed to 'static' or 'breathing' keeping wallpaper colors

openrgb --device logitech \
	--color ${color1:1},${color2:1},${color3:1} \
	--brightness 100 --speed 1
