#!/bin/bash

# Función para instalar npm en sistemas Debian/Ubuntu


install_npm_debian() {
    echo "Detected Debian/Ubuntu-based system. Installing npm with NVM..."

    # Descargar e instalar NVM
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Instalar la versión de Node.js que necesitas
    nvm install 18
    nvm use 18

    # Verificar instalación
    if command -v npm &> /dev/null; then
        echo "npm installed successfully!"
        npm -v
    else
        echo "Failed to install npm."
    fi
}


# Función para instalar npm en macOS usando Homebrew
install_npm_macos() {
    echo "Detected macOS system. Installing npm using Homebrew..."

    # Verificar si Homebrew está instalado
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Instalar Node.js (y npm)
    brew install node

    # Verificar instalación
    if command -v npm &> /dev/null; then
        echo "npm installed successfully!"
        npm -v
    else
        echo "Failed to install npm."
    fi
}

# Función para instalar npm en Windows
install_npm_windows() {
    echo "Detected Windows system. Please download and install Node.js from: https://nodejs.org/"
    echo "After installation, you can verify it by running 'npm -v' in the Command Prompt."
}

# Detección del sistema operativo
OS_TYPE=$(uname -s)

case "$OS_TYPE" in
    Linux)
        # Verificar si es Debian/Ubuntu
        if [ -f /etc/debian_version ]; then
            install_npm_debian
        else
            echo "Linux distribution not supported. Please manually install npm."
        fi
        ;;
    Darwin)
        install_npm_macos
        ;;
    MINGW*|MSYS*)
        install_npm_windows
        ;;
    *)
        echo "Unsupported OS: $OS_TYPE. Please manually install npm."
        ;;
esac

