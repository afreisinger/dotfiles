#!/bin/bash

# Function to display informational messages
info() {
    echo "[INFO] $1"
}

# Detect the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    info "Installing direnv on Linux..."
    
    # Check if the system is Debian/Ubuntu
    if [ -f /etc/debian_version ]; then
        info "Debian/Ubuntu-based system. Installing direnv..."
        sudo apt update
        sudo apt install -y direnv
    else
        info "Linux system not supported by this script. Use your distribution's package manager."
        exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    info "Installing direnv on macOS..."
    if ! command -v brew &> /dev/null; then
        info "Homebrew is not installed. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install direnv

else
    info "Operating system not supported by this script. Only Linux and macOS are supported."
    exit 1
fi

# Configure the shell (Bash or Zsh)
info "Configuring the shell to use direnv..."

# Detect the current shell
SHELL_NAME=$(basename "$SHELL")

# if [[ "$SHELL_NAME" == "zsh" ]]; then
#     echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc
#     info "Configured for Zsh."
# elif [[ "$SHELL_NAME" == "bash" ]]; then
#     echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
#     info "Configured for Bash."
# else
#     info "Shell configuration not supported. Only Bash and Zsh are supported."
#     exit 1
# fi

# Reload the shell configuration file
info "Reloading shell configuration file..."
if [[ "$SHELL_NAME" == "zsh" ]]; then
    source ~/.zshrc
elif [[ "$SHELL_NAME" == "bash" ]]; then
    source ~/.bashrc
fi

# Verify if direnv is installed correctly
if command -v direnv &> /dev/null; then
    info "direnv installed and configured successfully."
else
    info "There was an issue with the installation of direnv."
    exit 1
fi
