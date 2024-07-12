#!/bin/bash

CURRENT_TIME=$(date +%H%M)
SOURCE_DIR="$HOME"
BACKUP_DIR="/tmp/backup"
BACKUP_FILE="$BACKUP_DIR/backup_$CURRENT_TIME.tar.gz"
mkdir -p "$BACKUP_DIR"
rsync -a --exclude "$BACKUP_DIR" "$SOURCE_DIR/" "$BACKUP_DIR"
tar -czf "$BACKUP_FILE" -C "$BACKUP_DIR" .
rm -rf "$BACKUP_DIR"/*
echo "Backup completo: $BACKUP_FILE"
