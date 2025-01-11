#!/bin/bash

# Determinar el shell actual
SHELL_NAME=$(basename "$SHELL")

# Función para instalar y configurar 'z' en el shell adecuado
    echo "Installing 'z'..."

    # Clonar el repositorio de 'z' en el directorio home
    wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O "$HOME/z.sh"
    chmod +x "$HOME/bin/z.sh"
    #git clone https://github.com/rupa/z.git "$HOME/.z"

    # Verificar si el archivo de configuración ya tiene 'z'
    # if [[ "$SHELL_NAME" == "bash" ]]; then
    #     # Si es bash, añadir la línea en .bashrc
    #     if ! grep -q 'source $HOME/.z/z.sh' "$HOME/.bashrc"; then
    #         echo "source $HOME/.z/z.sh" >> "$HOME/.bashrc"
    #     fi
    #     echo "'z' installed for bash."
    #     echo "Please restart your terminal or run 'source ~/.bashrc' to start using it."
    # elif [[ "$SHELL_NAME" == "zsh" ]]; then
    #     # Si es zsh, añadir la línea en .zshrc
    #     if ! grep -q 'source $HOME/.z/z.sh' "$HOME/.zshrc"; then
    #         echo "source $HOME/.z/z.sh" >> "$HOME/.zshrc"
    #     fi
    #     echo "'z' installed for zsh."
    #     echo "Please restart your terminal or run 'source ~/.zshrc' to start using it."
    # else
    #     echo "Unsupported shell: $SHELL_NAME"
    #     exit 1
    # fi
