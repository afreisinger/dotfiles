#!/bin/bash

# Function to install jq on Debian/Ubuntu-based systems
install_jq_debian() {
    echo "Detected Debian/Ubuntu-based system. Installing jq..."

    sudo apt-get update
    sudo apt-get install -y jq

    # Verify installation
    if command -v jq &> /dev/null; then
        echo "jq installed successfully!"
        jq --version
    else
        echo "Failed to install jq."
    fi
}

# Function to install jq on macOS using Homebrew
install_jq_macos() {
    echo "Detected macOS system. Installing jq using Homebrew..."

    # Verify if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install jq
    brew install jq

    # Verify installation
    if command -v jq &> /dev/null; then
        echo "jq installed successfully!"
        jq --version
    else
        echo "Failed to install jq."
    fi
}

# Function to install jq on Windows using Chocolatey
install_jq_windows() {
    echo "Detected Windows system. Installing jq using Chocolatey..."

    # Check if Chocolatey is installed
    if ! command -v choco &> /dev/null; then
        echo "Chocolatey is not installed. Please install Chocolatey from https://chocolatey.org."
        exit 1
    fi

    # Install jq
    choco install jq -y

    # Verify installation
    if command -v jq &> /dev/null; then
        echo "jq installed successfully!"
        jq --version
    else
        echo "Failed to install jq."
    fi
}

# Detect the operating system and install jq accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/debian_version ]; then
        install_jq_debian
    else
        echo "Unsupported Linux distribution. Please install jq manually."
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_jq_macos
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    install_jq_windows
else
    echo "Unsupported OS. Please install jq manually."
fi
