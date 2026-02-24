#!/usr/bin/env bash
if [ -z "$*" ]; then exit 0; fi

QUERY=$(echo "$*" | sed 's/ /+/g')

# Nota: Anna's Archive a veces cambia de dominio. Si .org falla, prueba .li o .se
nohup xdg-open "https://annas-archive.li/search?q=$QUERY" >/dev/null 2>&1 &
