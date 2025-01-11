#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
#pushd "$ROOT" > /dev/null

echo $ROOT

source "$ROOT/shared.lib"


# Check if the keyrings directory exists
if [ ! -d "/etc/apt/keyrings" ]; then
    sudo mkdir -p /etc/apt/keyrings
fi

# Check if the GPG key already exists to avoid downloading it again
if [ ! -f "/etc/apt/keyrings/charm.gpg" ]; then
    echo "Charm GPG key not found. Downloading..."
    #download_file https://repo.charm.sh/apt/gpg.key . "$SCRIPT_DIR/install.log"
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
else
    echo "Charm GPG key already exists."
fi

# Add Charm repository to APT sources if not already added
if ! grep -q "repo.charm.sh" /etc/apt/sources.list.d/charm.list; then
    echo "Adding Charm repository to APT sources..."
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
else
    echo "Charm repository already added."
fi

# Update APT and install glow
sudo apt update && sudo apt install -y glow

#popd > /dev/null
