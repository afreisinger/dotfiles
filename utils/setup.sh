#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd "$SCRIPT_DIR" > /dev/null

ROOT="$SCRIPT_DIR/.."
source "$ROOT/shared.lib"


if [[ ! -e ~/bin ]]; then
    mkdir ~/bin
fi



if ! command_exists millis ; then
    h2 "Installing 'millis'"
    pushd millis > /dev/null
    #make install > /dev/null
    make install
    popd > /dev/null
fi

if ! command_exists signal-reset; then
    h2 "Installing 'signal-reset'"
    pushd signal-reset > /dev/null
    make > /dev/null
    cp signal-reset $HOME/bin/
    popd > /dev/null
fi

# inotify-info
# The better native version of my own script :D
# Check if the system is neither Mac nor WSL, and if 'inotify-info' is not installed
if [[ "$is_mac" != true ]] && [[ "$is_wsl" != true ]] && ! command -v inotify-info &> /dev/null; then
    h2 "Installing 'inotify-info'"  
    # Navigate to the inotify-info directory
    pushd inotify-info > /dev/null
    # Run make and suppress the output
    make > /dev/null
    # Copy the binary to ~/bin/
    cp _release/inotify-info ~/bin/
    # Return to the previous directory
    popd > /dev/null
fi


# fetch-todays-calendar
# A Node.js script that interacts with the Google Calendar API to fetch today's events
if (! command_exists fetch-todays-calendar); then
    h2 "Installing 'fetch-todays-calendar'"
    WRAPPER="$HOME/bin/fetch-todays-calendar"
    pushd fetch-todays-calendar > /dev/null
    npm set loglevel error
    npm install --silence > /dev/null 2>&1
    #npm install --info --no-progress
    popd > /dev/null
    command cat > $WRAPPER <<__DELIM
#!/usr/bin/env bash
# vi: ft=bash

cd "${SCRIPT_DIR}/fetch-todays-calendar"
node app.js \$@
__DELIM
    chmod +x "$WRAPPER"
fi

# symlink all scripts
#ln -sf "$SCRIPT_DIR/scripts/"* $HOME/bin/

#h3 'Installing dependencies for scripts'
#h3 'Python dependencies'
#(python3 -m pip install --user smsutil && python3 -m pip install --user requests ) | grep -v 'Requirement already satisfied'

if command_exists npm; then
    h2 "Installing 'node' dependencies"
    npm install --silence > /dev/null
    #npm install --info --no-progress
fi


# Restore current directory of user
popd > /dev/null
