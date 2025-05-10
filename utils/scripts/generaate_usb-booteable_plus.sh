#!/bin/bash

set -e

ISO="ubuntu-22.04.5-desktop-amd64.iso"
DISK="/dev/rdisk8"  # Cambiar según corresponda (¡sin número de partición!)
VOLUME_PATH="/Volumes/EFI"  # Nombre esperado de la partición EFI
USERNAME="afreisinger" 
LOCALE="es_AR.UTF-8"  # Cambia a es_AR, es_CL, etc.

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

echo "✅ ISO escrita. Reconectando y montando partición EFI..."
diskutil eject "$DISK"
sleep 5  # Espera para reconectar
echo "Por favor, desconecta y reconecta el USB, luego presiona Enter."
read -p ""

# Intentar montar la partición EFI
echo "🔍 Intentando montar partición EFI..."
diskutil mountDisk "$DISK" || {
  echo "⚠️ No se pudo montar con mountDisk. Intentando partición específica..."
  diskutil mount "${DISK}s1" || {
    echo "⚠️ No se pudo montar ${DISK}s1. Intentando en modo solo lectura..."
    diskutil mount readOnly "${DISK}s1" && {
      echo "❌ Montado en modo solo lectura. No se pueden añadir archivos."
      echo "Por favor, reescribe la ISO o usa otro USB."
      diskutil eject "$DISK"
      exit 1
    } || {
      echo "❌ No se pudo montar la partición. Verifica el USB o la ISO."
      echo "Sugerencia: Prueba con Balena Etcher o reformatea el USB."
      diskutil eject "$DISK"
      exit 1
    }
  }
}

# Verificar punto de montaje
if [ -d "$VOLUME_PATH" ]; then
  echo "✅ Partición montada en $VOLUME_PATH"
else
  echo "🔍 Buscando volumen montado..."
  VOLUME_PATH=$(ls /Volumes | grep -i "EFI\|Ubuntu" | head -n 1)
  if [ -z "$VOLUME_PATH" ]; then
    echo "❌ No se encontró un volumen montado. Verifica el USB."
    diskutil eject "$DISK"
    exit 1
  fi
  VOLUME_PATH="/Volumes/$VOLUME_PATH"
  echo "✅ Encontrado volumen en $VOLUME_PATH"
fi

# Asegurar permisos de escritura
echo "🔧 Asegurando permisos de escritura..."
sudo mount -uw "$VOLUME_PATH" || {
  echo "⚠️ No se pudo hacer el volumen escribible. Continuando..."
}

# Crear carpeta nocloud
echo "📁 Creando carpeta /nocloud..."
mkdir -p "$VOLUME_PATH/nocloud"

# Crear archivo user-data
echo "📝 Creando user-data..."
cat > "$VOLUME_PATH/nocloud/user-data" << EOF
#cloud-config
autoinstall:
  version: 1
  identity:
    hostname: bee
    username: $USERNAME
    password: "qwer" # Genera con: openssl passwd -6
  storage:
    layout:
      name: custom
      match:
        path: /dev/nvme0n1
    config:
      - type: disk
        id: disk0
        path: /dev/nvme0n1
        ptable: gpt
        wipe: superblock
      - type: partition
        id: efi-part
        device: disk0
        size: 300M
        flag: boot
        fstype: fat32
      - type: partition
        id: boot-part
        device: disk0
        size: 1G
        fstype: ext4
      - type: partition
        id: root-part
        device: disk0
        size: 150G
        fstype: btrfs
      - type: partition
        id: swap-part
        device: disk0
        size: 32G
        fstype: swap
      - type: partition
        id: home-part
        device: disk0
        size: -1
        fstype: ext4
      - type: mount
        device: efi-part
        path: /boot/efi
      - type: mount
        device: boot-part
        path: /boot
      - type: mount
        device: root-part
        path: /
      - type: mount
        device: home-part
        path: /home
      - type: swap
        device: swap-part
  packages:
    - btrfs-progs
    - grub-efi
  late-commands:
    - curtin in-target -- apt-get update
    - curtin in-target -- snapper --config root create-config /
    - curtin in-target -- snapper --config root set-config TIMELINE_CREATE=yes TIMELINE_CLEANUP=yes
  keyboard:
    layout: la
    variant: latin
  locale: $LOCALE
EOF

# Crear archivo meta-data
echo "📝 Creando meta-data..."
touch "$VOLUME_PATH/nocloud/meta-data"

# Generar hash de contraseña
echo "🔑 Genera un hash para la contraseña:"
openssl passwd -6
echo "Copia el hash y actualiza el campo 'password' en $VOLUME_PATH/nocloud/user-data."

# Verificar archivos
echo "🔍 Verificando archivos..."
ls -l "$VOLUME_PATH/nocloud"

echo "✅ Listo. Expulsando..."
diskutil eject "$DISK"
