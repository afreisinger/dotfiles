#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source_dir="$HOME/.dotfiles/common-setup/config"
target_dir="$HOME/.config"

find "$source_dir" -type d -print0 | while IFS= read -r -d '' dir; do
    new_dir="${dir/$source_dir/$target_dir}"
    mkdir -p "$new_dir"
    echo "Directorio creado: $new_dir"
done
