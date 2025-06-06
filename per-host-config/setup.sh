#!/bin/bash

# Put your machine name in this file. 
# The name must match one of the subdirectories in this dir
MACHINE_NAME_FILE="$HOME/.dotfiles-machine"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd "$SCRIPT_DIR" > /dev/null

# Get some color codes
ROOT="$SCRIPT_DIR/.."
source "$ROOT/shared.lib"

if [[ ! -e $MACHINE_NAME_FILE ]]; then
    warn "Missing name of this machine in $MACHINE_NAME_FILE" 
    info "Create it like this: \"echo my-computer-name > $MACHINE_NAME_FILE\""
    exit 1
fi

MACHINE=$(cat "$MACHINE_NAME_FILE")

if [[ -e "$MACHINE" ]]; then 
    h1 "Setting up local settings for this machine -$MACHINE-" 
    cd $MACHINE
    ln -sf `pwd`/bashrc.local "$HOME/.bashrc.local"
    ln -sf `pwd`/profile.local "$HOME/.profile.local"
    ln -sf `pwd`/gitlocal "$HOME/.gitlocal"
    #ln -sf `pwd`/vimrc.local "$HOME/.vimrc.local"  
    [[ -e ./setup.sh ]] && ./setup.sh

    warn "You *might* need to re-run the global setup as build tools might not have been available"
else
    error "Missing local settings directory: $SCRIPT_DIR/$MACHINE"
fi

popd >> /dev/null
