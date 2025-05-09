#!/bin/bash

set -e

echo "[+] Actualizando lista de paquetes..."
sudo apt update

echo "[+] Instalando Timeshift..."
# Desde Ubuntu 20.04 en adelante, Timeshift está en el repositorio universe
sudo apt install -y timeshift
