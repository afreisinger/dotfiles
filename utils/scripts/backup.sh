#!/bin/bash

# Configuración
BACKUP_DIR="$HOME/backup_$(date +%Y%m%d_%H%M%S)"
FILES_TO_BACKUP=("$HOME/.ssh" "$HOME/.bashrc" "$HOME/.profile")

# Crear el directorio de backup
mkdir -p "$BACKUP_DIR" || {
    echo "Error: No se pudo crear el directorio de respaldo."
    exit 1
}

# Copiar los archivos al directorio de backup
for file in "${FILES_TO_BACKUP[@]}"; do
    if [ -e "$file" ]; then
        cp -r "$file" "$BACKUP_DIR" || {
            echo "Error: No se pudo respaldar $file"
        }
    else
        echo "Advertencia: $file no existe. Omitido."
    fi
done

echo "Respaldo completado. Archivos almacenados en: $BACKUP_DIR"

