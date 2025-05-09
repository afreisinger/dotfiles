#!/bin/bash

set -e

echo "[+] Actualizando lista de paquetes..."
sudo apt update
echo "[+] Instalando 'software-properties-common'..."
sudo apt install -y software-properties-common
echo "[+] Agregando PPA oficial de Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
echo "[+] Instalando Ansible..."
sudo apt install -y ansible
echo "[✔] Instalación completa. Versión instalada:"
ansible --version

