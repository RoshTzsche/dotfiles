#!/bin/bash
#importamos la paleta desde piwal
source /home/ateniense/.cache/wal/colors.sh

lenovo = $(openrgb --list-devices | grep -i "NOMBRE" | head -n 1 | awk -F ':' '{print $1}')

logitech = $(openrgb --list-devices | grep -i "NOMBRE" | head -n 1 | awk -F ':' '{print $1}')


openrgb --device lenovo \
	--color ${color1:1},${color2:1},${color3:1},${color4:1} \
	--mode static --brightness 100 --speed 1

# mode se peude cambiar a static y breathing manteniendo los colores del wallpaper
#
openrgb --device logitech \
	--color ${color1:1},${color2:1},${color3:1} \
	--brightness 100 --speed 1



