#!/bin/bash

# Archivo "buzón" para comunicar con el script de Python vivo
CONFIG_FILE="/tmp/pomodoro_config.json"

# Función para aplicar configuración sin matar el proceso
apply_config() {
    # $1=Work, $2=Short, $3=Long, $4=Cycles
    # Creamos el JSON
    echo "{\"work\": $1, \"short_break\": $2, \"long_break\": $3, \"cycles\": $4}" > "$CONFIG_FILE"
    
    # Enviamos señal SIGUSR2 para que Python lea el archivo y reinicie
    pkill -SIGUSR2 -f pomodoro.py
}

# Opciones del menú
OPC1="Estándar (25m / 4 ciclos)"
OPC2="Deep Work (50m / 2 ciclos)"
OPC3="Speed Run (15m / 6 ciclos)"
OPC_CUSTOM="Personalizado..."
OPC_RESET="Resetear (Reinicia contador)"
OPC_STOP="Detener/Salir"

# Selector Wofi
CHOICE=$(echo -e "$OPC1\n$OPC2\n$OPC3\n$OPC_CUSTOM\n$OPC_RESET\n$OPC_STOP" | wofi --show dmenu --width 400 --height 300 --prompt "Control Pomodoro")

case "$CHOICE" in
    "$OPC1")
        # 25m trabajo, 5m corto, 15m largo, 4 ciclos
        apply_config 25 5 15 4
        ;;
    "$OPC2")
        # 50m trabajo, 10m corto, 15m largo, 2 ciclos
        apply_config 50 10 15 2
        ;;
    "$OPC3")
        # 15m trabajo, 3m corto, 10m largo, 6 ciclos
        apply_config 15 3 10 6
        ;;
    "$OPC_CUSTOM")
        # Pedir datos al usuario
        WORK=$(echo -e "25\n50\n45\n60" | wofi --show dmenu --prompt "Minutos de trabajo:")
        [ -z "$WORK" ] && exit 0
        
        CYCLES=$(echo -e "4\n2\n3\n6" | wofi --show dmenu --prompt "Ciclos antes de descanso largo:")
        [ -z "$CYCLES" ] && exit 0
        
        # Asumimos descansos estándar (5 y 15) o podrías pedirlos también
        apply_config $WORK 5 15 $CYCLES
        ;;
    "$OPC_RESET")
        # Solo reinicia el contador con la config actual
        pkill -SIGUSR2 -f pomodoro.py
        ;;
    "$OPC_STOP")
        # Mata el proceso completamente
        pkill -f pomodoro.py
        ;;
esac
