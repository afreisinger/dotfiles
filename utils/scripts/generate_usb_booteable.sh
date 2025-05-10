#!/bin/bash

set -e

ISO="ubuntu-22.04.5-desktop-amd64.iso"
DISK="/dev/disk8"  # Cambiar según corresponda (¡sin número de partición!)

echo "⚠️  ATENCIÓN: Vas a escribir en $DISK"
read -p "¿Estás seguro? Esto borrará todo el contenido. (yes/no): " CONFIRM

if [[ "$CONFIRM" != "yes" ]]; then
  echo "Cancelado."
  exit 1
fi

echo "📤 Desmontando disco..."
diskutil unmountDisk "$DISK"

echo "📝 Escribiendo imagen ISO en el disco..."
sudo dd if="$ISO" of="$DISK" bs=4194304 conv=sync

echo "✅ Listo. Expulsando..."
diskutil eject "$DISK"

