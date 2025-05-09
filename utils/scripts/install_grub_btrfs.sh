#!/bin/bash

set -e

cd "$HOME"

echo "[+] Instalando dependencias..."
sudo apt update
sudo apt install -y \
    timeshift \
    btrfs-progs \
    grub-common \
    bash \
    gawk \
    inotify-tools \
    git \
    make

echo "[+] Clonando e instalando grub-btrfs..."
git clone https://github.com/Antynea/grub-btrfs.git /tmp/grub-btrfs
cd /tmp/grub-btrfs
sudo make install

echo "[+] Volviendo al HOME antes de borrar grub-btrfs..."
cd "$HOME"
rm -rf /tmp/grub-btrfs

echo "[+] Preparando instalación de timeshift-autosnap-apt..."
if [ -d "$HOME/timeshift-autosnap-apt" ]; then
    echo "[!] timeshift-autosnap-apt ya está presente en $HOME. Saltando clonación e instalación."
else
    echo "[+] Clonando e instalando timeshift-autosnap-apt..."
    git clone https://github.com/wmutschl/timeshift-autosnap-apt.git "$HOME/timeshift-autosnap-apt"
    cd "$HOME/timeshift-autosnap-apt"
    sudo make install
fi

echo "[+] Regenerando GRUB para que detecte snapshots..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "[✔] Instalación completa: Timeshift, autosnap y grub-btrfs funcionando con Btrfs."

