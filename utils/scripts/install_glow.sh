#!/bin/bash

sudo mkdir -p /etc/apt/keyrings
if ! command -v curl &> /dev/null
then
    echo "curl is not installed. Installing it..."
    sudo apt update
    sudo apt install -y curl
fi
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install glow