#!/bin/bash

# --- CONFIGURACIÓN ---
LIBRARY_PATH="$HOME/Books/calibre/"

# --- VALIDACIÓN ---
if [ ! -d "$LIBRARY_PATH" ]; then
    echo "❌ Error: No encuentro la biblioteca en: $LIBRARY_PATH"
    exit 1
fi

# --- EXTRACCIÓN (Optimización: Raw JSON) ---
RAW_DATA=$(calibredb list \
    --with-library "$LIBRARY_PATH" \
    --for-machine \
    --fields title,authors,formats)

if [ -z "$RAW_DATA" ] || [ "$RAW_DATA" == "[]" ]; then
    echo "⚠️  Biblioteca vacía o error de conexión."
    exit 1
fi

# --- PROCESAMIENTO JQ (CORREGIDO) ---
# Aquí está la magia de la corrección:
# if type=="array" then join(", ") else . end
# Esto verifica el tipo de dato del campo 'authors' antes de tocarlo.

LIST_FORMATTED=$(echo "$RAW_DATA" | jq -r '
  .[] 
  | select(.formats | length > 0) 
  | "\(.title)  |  \(.authors | if type=="array" then join(", ") else . end) \t\(.formats[0])"
')

# --- INTERFAZ FZF ---
SELECTED=$(echo "$LIST_FORMATTED" | fzf \
    --delimiter "\t" \
    --with-nth 1 \
    --prompt "📚 Biblioteca > " \
    --height 50% \
    --layout=reverse \
    --border \
    --info=inline \
    --ansi)

[ -z "$SELECTED" ] && exit 0

# --- EJECUCIÓN ---
FILE_PATH=$(echo "$SELECTED" | awk -F'\t' '{print $2}')
if [ -f "$FILE_PATH" ]; then
    # --- LA MAGIA DEL DESACOPLAMIENTO ---
    # setsid -f : Forkea en el background en una nueva sesión.
    # >/dev/null 2>&1 : Silencia cualquier output (warnings de GTK/font) para que no ensucie la terminal.
    setsid -f zathura "$FILE_PATH" >/dev/null 2>&1
    
    # Opcional: Mensaje de confirmación efímero
    echo "📖 Abriendo libro en segundo plano..."
    sleep 0.5
else
    echo "❌ Archivo fantasma (base de datos desactualizada): $FILE_PATH"
fi
