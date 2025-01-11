#!/bin/bash
# export DEBUG=1
# Determine the Git repository root
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "ERROR: Unable to determine Git repository root. Are you inside a Git repository?" >&2
    exit 1
}

# Export ROOT so it's available for other scripts
export ROOT

# Load shared functions
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$SCRIPT_DIR/shared.lib"


# Check if the script is running as root
# https://www.shellcheck.net/wiki/SC2181

if [ "$(id -u)" -ne 0 ]; then
    info "This script requires superuser privileges. Requesting 'sudo' access..."
    if ! sudo -v; then
        info "Failed to obtain sudo privileges. Exiting..."
        exit 1
    fi

    while true; do
        sleep 60
        if ! sudo -n true; then
            info "Lost sudo privileges. Exiting..."
            exit 1
        fi
    done &
fi


#pushd "$SCRIPT_DIR" > /dev/null
safe_pushd "$SCRIPT_DIR"

h1 "Installing common setup"

# Initialize Git submodules if present
if [[ -f .gitmodules ]]; then
    info "Initializing Git submodules..."
    git submodule init
    git submodule update
else
    info "No submodules found. Skipping initialization."
fi

[[ -x common-setup/setup.sh ]] || fail "common-setup/setup.sh not found or not executable"
common-setup/setup.sh || fail "Failed common setup"

h1 "Install config specific to this machine"
echo 'ubuntu' > ~/.dotfiles-machine
chmod 600 ~/.dotfiles-machine
[[ -x per-host-config/setup.sh ]] || fail "per-host-config/setup.sh not found or not executable"
per-host-config/setup.sh || fail "Failed machine-specific setup"

# Add the little `millis` util for cross-platform millisecond support
h1 "Adding scripts and binary utilities"
[[ -x utils/setup.sh ]] || fail "utils/setup.sh not found or not executable"
utils/setup.sh || fail "Failed utils setup"

# Restore current directory of user
safe_popd

# Re-read BASH settings
banner "Remember to 'source ~/.bashrc'!"
