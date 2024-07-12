#!/bin/bash

CT=$(date +%H%M)
SD="$HOME"
BD="/tmp/backup"
BF="$BD/backup_$CT.tar.gz"
mkdir -p "$BD"
rsync -a --exclude "$BD" "$SD/" "$BD"
tar -czf "$BF" -C "$BD" .
rm -rf "$BD"/*
echo "Backup completo: $BF"
