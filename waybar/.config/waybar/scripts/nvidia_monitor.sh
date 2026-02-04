#!/bin/bash

# Verificamos si la GPU está accesible (si está en reposo profundo, el comando fallará o retornará error)
if ! nvidia-smi > /dev/null 2>&1; then
    # Estado: OFF / Dormida
    echo '{"text": " OFF", "tooltip": "RTX 3070 sleeping", "class": "off"}'
else
    # Estado: ON / Activa
    # Extraemos Temperatura, Uso de GPU y VRAM
    DATA=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used --format=csv,noheader,nounits)
    
    # Separamos las variables (IFS es el separador de campo interno)
    IFS=',' read -r TEMP USAGE VRAM <<< "$DATA"
    
    # Limpiamos espacios en blanco
    TEMP=$(echo $TEMP | xargs)
    USAGE=$(echo $USAGE | xargs)
    VRAM=$(echo $VRAM | xargs)

    # Formato JSON para Waybar
    echo "{\"text\": \"$TEMP°C\", \"tooltip\": \"RTX 3070 Active\nUsage: $USAGE%\nVRAM: ${VRAM}MiB\", \"class\": \"on\"}"
fi
