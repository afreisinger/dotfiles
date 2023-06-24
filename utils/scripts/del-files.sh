#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SCRIPT_DIR
# Ruta del archivo de texto que contiene la lista de archivos y directorios a eliminar
archivo_lista=~/".files"
cd $HOME
# Verificar si el archivo de lista existe
if [ -f "$archivo_lista" ]; then
    # Leer línea por línea del archivo de lista
    while IFS= read -r linea || [[ -n "$linea" ]]; do
        # Eliminar espacios en blanco al inicio y final de la línea
        linea=$(echo "$linea" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        # Verificar si la línea no está vacía
        if [ -n "$linea" ]; then
            # Verificar si el archivo o directorio existe
            if [ -e "$linea" ]; then
                # Verificar si es un archivo o directorio
                if [ -f "$linea" ] || [ -L "$linea" ]; then
                    # Es un archivo o enlace simbólico, eliminarlo
                    echo "Eliminando archivo: $linea"
                    rm "$linea"
                elif [ -d "$linea" ]; then
                    # Es un directorio, eliminarlo de forma recursiva
                    echo "Eliminando directorio: $linea"
                    rm -r "$linea"
                else
                    echo "No se pudo determinar el tipo de archivo o directorio: $linea"
                fi
            else
                echo "El archivo o directorio no existe: $linea"
            fi
        fi
    done < "$archivo_lista"
else
    echo "El archivo de lista no existe: $archivo_lista"
fi
