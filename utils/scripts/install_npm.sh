#!/bin/bash

# Función para mostrar mensajes de información
info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

# Función para mostrar mensajes de error
error() {
    echo -e "\e[31m[ERROR]\e[0m $1" >&2
    exit 1
}

# Verificar si npm está instalado
if ! command -v npm &>/dev/null; then
    error "npm no está instalado. Por favor, instala Node.js antes de continuar."
fi

# Obtener la versión instalada de npm
installed_version=$(npm -v)
info "Versión actual de npm instalada: $installed_version"

# Obtener la última versión disponible de npm
latest_version=$(npm show npm version)

if [ "$installed_version" != "$latest_version" ]; then
    info "Hay una nueva versión de npm disponible: $latest_version"
    info "Actualizando npm a la última versión..."

    # Actualizar npm
    npm install -g npm
    if [ $? -eq 0 ]; then
        info "npm actualizado con éxito a la versión $(npm -v)"
    else
        error "La actualización de npm falló. Por favor, verifica los permisos o problemas de red."
    fi
else
    info "Ya tienes la última versión de npm instalada ($installed_version)."
fi
