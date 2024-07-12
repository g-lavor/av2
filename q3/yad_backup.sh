#!/bin/bash

if ! command -v yad>/dev/null; then
    echo "Yad não está instalado. Por favor, instale yad para continuar."
    exit 1
fi

C=$(yad --title "Agendar Backup" \
        --form \
        --field="Data e Hora:DT" \
        --button="Agendar:0"--button="Cancelar:1" \
        --center \
        --width=400 \
        --date-format="%Y-%m-%d %H:%M")

if [ $? -ne 0 ]; then
    echo "Operação cancelada."
    exit 1
fi

D=$(echo "$C" | awk -F '|' '{print $1}')

A=$(date -d "$D" +"%H:%M %m/%d/%Y")

S="$HOME"
B="/tmp/backup"

mkdir -p "$B"

rsync -a --exclude="$B" "$S/" "$B"

F="$B/backup_$(date -d "$D" +%Y%m%d_%H%M).tar.gz"

tar -czf "$F" -C "$B" .

rm -rf "$B"/*

P=$(realpath "$0")

echo "$P" | at "$A"
echo "Backup agendado para $D."

exit 0
