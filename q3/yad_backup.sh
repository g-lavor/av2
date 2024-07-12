#!/bin/bash

if ! command -v yad > /dev/null; then
    echo "Yad não está instalado. Por favor, instale yad para continuar."
    exit 1
fi

CHOICE=$(yad --title "Agendar Backup" \
             --form \
             --field="Data e Hora:DT" \
             --button="Agendar:0" --button="Cancelar:1" \
             --center \
             --width=400 \
             --date-format="%Y-%m-%d %H:%M")

if [ $? -ne 0 ]; then
    echo "Operação cancelada."
    exit 1
fi

DATETIME=$(echo "$CHOICE" | awk -F '|' '{print $1}')

AT_TIME=$(date -d "$DATETIME" +"%H:%M %m/%d/%Y")

SOURCE_DIR="$HOME"
BACKUP_DIR="/tmp/backup"

mkdir -p "$BACKUP_DIR"

rsync -a --exclude "$BACKUP_DIR" "$SOURCE_DIR/" "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/backup_$(date -d "$DATETIME" +%Y%m%d_%H%M).tar.gz"

tar -czf "$BACKUP_FILE" -C "$BACKUP_DIR" .

rm -rf "$BACKUP_DIR"/*

SCRIPT_PATH=$(readlink -f "$0")

echo "$SCRIPT_PATH" | at "$AT_TIME"
echo "Backup agendado para $DATETIME."

exit 0
