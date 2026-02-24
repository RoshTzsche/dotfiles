#!/usr/bin/env bash

if [ -z "$*" ]; then exit 0; fi

QUERY=$(echo "$*" | sed 's/ /+/g')

nohup xdg-open "https://duckduckgo.com/?q=$QUERY" >/dev/null 2>&1 &
