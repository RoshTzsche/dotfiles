#!/usr/bin/env python3
import time
import json
import sys
import signal
import argparse
import logging
import subprocess
import os

# --- CONFIGURACIÓN ---
CONFIG_FILE = '/tmp/pomodoro_config.json'
LOG_FILE = '/tmp/pomodoro.log'

# Configurar logging
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.DEBUG,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# --- VARIABLES GLOBALES ---
state = "work"
timer = 0
cycles = 0
# CAMBIO CLAVE: Empieza en False para estar PAUSADO al inicio
running = False 
work_time = 25 * 60
short_break = 5 * 60
long_break = 15 * 60
cycles_interval = 4 # Ciclos antes del descanso largo

# --- FUNCIONES AUXILIARES ---

def send_notification(message):
    try:
        subprocess.run(['notify-send', '🍅 Pomodoro', message], 
                      stderr=subprocess.DEVNULL, 
                      stdout=subprocess.DEVNULL)
    except Exception as e:
        logging.warning(f"notify-send error: {e}")

def load_config():
    """Lee la configuración desde el archivo temporal sin reiniciar el proceso"""
    global work_time, short_break, long_break, cycles_interval
    try:
        if os.path.exists(CONFIG_FILE):
            with open(CONFIG_FILE, 'r') as f:
                config = json.load(f)
                if 'work' in config: work_time = config['work'] * 60
                if 'short_break' in config: short_break = config['short_break'] * 60
                if 'long_break' in config: long_break = config['long_break'] * 60
                if 'cycles' in config: cycles_interval = config['cycles']
            logging.info(f"Config loaded: {config}")
    except Exception as e:
        logging.error(f"Error loading config: {e}")

def print_output():
    global state, timer, cycles, running
    try:
        minutes, seconds = divmod(timer, 60)
        
        if not running:
            # Estado PAUSADO: Icono de pausa o texto
            icon = "⏸"
            class_css = "paused"
            text_output = f"{icon} {minutes:02d}:{seconds:02d}"
        else:
            # Estado CORRIENDO
            state_prefix = {
                "work": "WORK",
                "short_break": "BREAK",
                "long_break": "LONG"
            }
            # Opcional: Iconos según estado
            icon = "🍅" if state == "work" else "☕"
            class_css = state
            text_output = f"[{state_prefix.get(state, 'TIMER')}] {minutes:02d}:{seconds:02d}"

        output = {
            "text": text_output,
            "class": class_css,
            "tooltip": (
                f"Status: {state.replace('_', ' ').title()}\n"
                f"Time: {minutes}m {seconds}s\n"
                f"Cycles: {cycles}/{cycles_interval}\n"
                f"Target: {work_time//60} min\n\n"
                "🖱 L-Click: Play/Pause\n"
                "🖱 M-Click: Menu\n"
                "🖱 R-Click: Reset"
            )
        }
        
        print(json.dumps(output), flush=True)
        sys.stdout.flush()
    except Exception as e:
        logging.error(f"Error in print_output: {e}")

# --- MANEJO DE SEÑALES ---

def signal_handler(sig, frame):
    global running, timer, state, cycles
    try:
        if sig == signal.SIGUSR1:
            # Click Izquierdo: Alternar Pausa/Play
            running = not running
            logging.info(f"SIGUSR1: running={running}")
            
        elif sig == signal.SIGUSR2:
            # Click Derecho o Menú: Cargar config y Resetear
            load_config() 
            state = "work"
            timer = work_time
            # Al resetear o cambiar modo, arrancamos automáticamente
            running = True 
            cycles = 0
            logging.info("SIGUSR2: reset/reconfig applied")
            
        print_output()
    except Exception as e:
        logging.error(f"Error in signal_handler: {e}")

signal.signal(signal.SIGUSR1, signal_handler)
signal.signal(signal.SIGUSR2, signal_handler)

# --- BUCLE PRINCIPAL ---

def pomodoro():
    global state, timer, cycles, running
    
    # Carga inicial de argumentos si los hubiera, o defaults
    timer = work_time
    
    while True:
        try:
            print_output()
            time.sleep(1)
            
            if running and timer > 0:
                timer -= 1
            
            if running and timer == 0:
                # Lógica de cambio de estado
                if state == "work":
                    send_notification("¡Tiempo terminado! Tómate un descanso.")
                    cycles += 1
                    if cycles % cycles_interval == 0:
                        state = "long_break"
                        timer = long_break
                    else:
                        state = "short_break"
                        timer = short_break
                elif state == "short_break":
                    send_notification("Descanso corto finiquitado. ¡A trabajar!")
                    state = "work"
                    timer = work_time
                elif state == "long_break":
                    send_notification("Descanso largo terminado. De vuelta al tajo.")
                    state = "work"
                    timer = work_time
                    cycles = 0 # Opcional: resetear ciclos tras descanso largo
        except Exception as e:
            logging.error(f"Error in main loop: {e}")
            time.sleep(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--work', type=int, default=25)
    parser.add_argument('--short-break', type=int, default=5)
    parser.add_argument('--long-break', type=int, default=15)
    parser.add_argument('--cycles', type=int, default=4)
    args = parser.parse_args()
    
    work_time = args.work * 60
    short_break = args.short_break * 60
    long_break = args.long_break * 60
    cycles_interval = args.cycles
    
    # Inicializamos el timer con el work_time definido
    timer = work_time

    try:
        pomodoro()
    except KeyboardInterrupt:
        sys.exit(0)
