#!/bin/bash


# Function to install npm on Debian/Ubuntu-based systems
install_npm_debian() {
    echo "Detected Debian/Ubuntu-based system. Installing npm with NVM..."

    # Download and install the latest version of NVM
    latest_version=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)
    curl -s -o- https://raw.githubusercontent.com/nvm-sh/nvm/$latest_version/install.sh | bash
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    # Install the specified version of Node.js or default to version 18
    node_version=${1:-20}
    nvm install $node_version
    nvm use $node_version

    export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"
}

# Function to install npm on macOS using Homebrew
install_npm_macos() {
    echo "Detected macOS system. Installing npm using Homebrew..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install Node.js (and npm)
    node_version=${1:-20}
    brew install node@$node_version

    # Verify installation
    if command -v npm &> /dev/null; then
        echo "npm installed successfully!"
        npm -v
    else
        echo "Failed to install npm."
    fi
}

# Function to install npm on Windows
install_npm_windows() {
    echo "Detected Windows system. Please download and install Node.js from: https://nodejs.org/"
    echo "After installation, you can verify it by running 'npm -v' in the Command Prompt."
}

# Detect the operating system



if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/debian_version ]; then
        
        if ! command -v jq &> /dev/null; then
            echo "jq is not installed. Proceeding with installation..."
            sudo apt update
            sudo apt install -y jq
        fi
        
        install_npm_debian "$1"
    else
        echo "Unsupported Linux distribution."
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_npm_macos "$1"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    install_npm_windows
else
    echo "Unsupported OS."
    exit 1
fi
