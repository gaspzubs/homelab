#!/bin/bash

# quitter en cas d'erreur
set -e
# --- VARIABLES ---
# Le dossier à sauvegarder
SOURCE_DIR="/home/<user>/Documents/homelab"
# L'endroit où stocker la sauvegarde (sur le NAS)
DEST_DIR="/mnt/nas/<shared-storage>/backups"
# Le nom du fichier avec la date (ex: backup_homelab_2023-10-27.tar.gz)
DATE=$(date +%Y-%m-%d)
FILENAME="backup_homelab_$DATE.tar.gz"

# --- 1. SAUVEGARDE ---
# On crée l'archive
# On exclut le dossier 'cache' de Jellyfin qui est lourd et inutile à sauvegarder
tar --exclude='*/jellyfin/cache' -czf "$DEST_DIR/$FILENAME" "$SOURCE_DIR"

# --- 2. NETTOYAGE ---
# On supprime les fichiers vieux de plus de 14 jours dans le dossier de destination
find "$DEST_DIR" -name "backup_homelab_*.tar.gz" -mtime +14 -delete

# --- 3. LOG (Optionnel) ---
echo "Sauvegarde du $DATE effectuée avec succès." >> /home/<user>/Documents/homelab/backup.log