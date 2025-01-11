#!/bin/bash

install_dependencies() {
    local dependencies_file="$1"

    # Verificar si el archivo fue proporcionado y existe
    if [[ -z "$dependencies_file" ]]; then
        echo "Error: No file path provided."
        exit 1
    elif [[ ! -f "$dependencies_file" ]]; then
        echo "Error: File '$dependencies_file' not found!"
        exit 1
    fi

    echo "Installing system dependencies from $dependencies_file..."

    # Leer las dependencias del archivo (ignorar líneas vacías y comentarios)
    dependencies=$(grep -v '^#' "$dependencies_file" | xargs)

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &>/dev/null; then
            echo "Detected APT package manager..."
            sudo apt update
            sudo apt install -y $dependencies
        elif command -v yum &>/dev/null; then
            echo "Detected YUM package manager..."
            sudo yum groupinstall "Development Tools" -y
            sudo yum install -y $dependencies
        else
            echo "Unsupported Linux distribution. Install dependencies manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Detected macOS with Homebrew..."
        if ! command -v brew &>/dev/null; then
            echo "Homebrew is not installed. Please install it first."
            exit 1
        fi
        xargs brew install < <(grep -v '^#' "$dependencies_file")
    else
        echo "Unsupported OS. Please install dependencies manually."
        exit 1
    fi

    echo "Dependencies installed successfully!"
}

# Ejemplo de uso
# Ruta al archivo de dependencias (puede ser pasada como argumento al script)
dependencies_file_path="$1"

if [[ -z "$dependencies_file_path" ]]; then
    echo "Usage: $0 /path/to/dependencies-file"
    exit 1
fi

install_dependencies "$dependencies_file_path"