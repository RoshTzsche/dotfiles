#!/bin/bash

# --- CONFIGURATION ---
LIBRARY_PATH="$HOME/Books/"

# --- VALIDATION ---
if [ ! -d "$LIBRARY_PATH" ]; then
    echo "❌ Error: Library not found at: $LIBRARY_PATH"
    exit 1
fi

# --- EXTRACTION (Optimization: Raw JSON) ---
RAW_DATA=$(calibredb list \
    --with-library "$LIBRARY_PATH" \
    --for-machine \
    --fields title,authors,formats)

if [ -z "$RAW_DATA" ] || [ "$RAW_DATA" == "[]" ]; then
    echo "⚠️  Empty library or connection error."
    exit 1
fi

# --- JQ PROCESSING (FIXED) ---
# Here is the fix magic:
# if type=="array" then join(", ") else . end
# This checks the data type of the 'authors' field before touching it.

LIST_FORMATTED=$(echo "$RAW_DATA" | jq -r '
  .[] 
  | select(.formats | length > 0) 
  | "\(.title)  |  \(.authors | if type=="array" then join(", ") else . end) \t\(.formats[0])"
')

# --- FZF INTERFACE ---
SELECTED=$(echo "$LIST_FORMATTED" | fzf \
    --delimiter "\t" \
    --with-nth 1 \
    --prompt "📚 Library > " \
    --height 50% \
    --layout=reverse \
    --border \
    --info=inline \
    --ansi)

[ -z "$SELECTED" ] && exit 0

# --- EXECUTION ---
FILE_PATH=$(echo "$SELECTED" | awk -F'\t' '{print $2}')
if [ -f "$FILE_PATH" ]; then
    # --- THE MAGIC OF DECOUPLING ---
    # setsid -f : Fork into background in a new session.
    # >/dev/null 2>&1 : Silence any output (GTK/font warnings) to keep terminal clean.
    setsid -f zathura "$FILE_PATH" >/dev/null 2>&1
    
    # Optional: Ephemeral confirmation message
    echo "📖 Opening book in background..."
    sleep 0.5
else
    echo "❌ Ghost file (outdated database): $FILE_PATH"
fi
