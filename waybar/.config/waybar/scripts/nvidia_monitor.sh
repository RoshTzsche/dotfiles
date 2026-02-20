#!/bin/bash

if ! nvidia-smi > /dev/null 2>&1; then
    echo '{"text": " OFF", "tooltip": "RTX 3070 sleeping", "class": "off"}'
else
    DATA=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,memory.used --format=csv,noheader,nounits)
    
    IFS=',' read -r TEMP USAGE VRAM <<< "$DATA"
    
    TEMP=$(echo $TEMP | xargs)
    USAGE=$(echo $USAGE | xargs)
    VRAM=$(echo $VRAM | xargs)

    echo "{\"text\": \"GPU:$TEMP°C\", \"tooltip\": \"RTX 3070 Active\nUsage: $USAGE%\nVRAM: ${VRAM}MiB\", \"class\": \"on\"}"
fi
