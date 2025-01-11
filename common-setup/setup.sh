#!/bin/bash
# Run to setup with ./setup.sh
#DEBUG=1

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT="$SCRIPT_DIR/.."
BASH_DIR="${HOME}/.bash.d"
BASH_D="$SCRIPT_DIR/bash_completion.d"

LOG_DIR="${HOME}/.logs"
LOG_FILE="$LOG_DIR/install.log"
SET_FILE="$LOG_DIR/setup.log"


source "$ROOT/shared.lib"
shopt -s expand_aliases
pushd "$SCRIPT_DIR" > /dev/null


[[ ! -e "$HOME"/.logs ]] && mkdir "$HOME/.logs"
[[ ! -e "$HOME"/.bash_completion.d ]] && mkdir "$HOME/.bash_completion.d"
[[ ! -e "$HOME"/.bash.d ]] && mkdir "$HOME/.bash.d"
[[ ! -e "$HOME"/.config ]] && mkdir "$HOME/.config"
[[ ! -e "$HOME"/bin ]] && mkdir "$HOME/bin"

# Redirect all output (stdout and stderr) to a log file
exec > >(tee -i "$SET_FILE") 2>&1

set -e  # Exit on error, treat unset variables as an error
[[ $DEBUG ]] && set -x

if [ -e "${HOME}/.secret" ]; then
  source "${HOME}/.secret"
fi

if [ -e "$HOME/.bash_profile" ]; then
    info "We don't use .bash_profile to avoid trouble. Renaming to .bash_profile.bak"
    mv "$HOME"/.bash_profile{,.bak}
fi


h2 "Clearing 'logs'"
if [ -d "$HOME/.logs" ]; then
    rm -rf "$HOME/.logs/*" 2>/dev/null
    info "Cleared all files in the directory $LOG_DIR"
else
    info "No 'logs' directory found"
fi


h2 "Installing some utilities"
install_tool() {
    local tool=$1
    local install_script=$2
    local log_file=$3

    # Verifica si la herramienta está instalada
    if  ! command -v "$tool" &>/dev/null; then
        info "'$tool' is not installed. Proceeding with installation..."
        
        # Redirige la salida y errores al archivo de log
        if ! "$install_script" >> "$log_file" 2>&1; then
            error "Failed to install '$tool'. Check the log at $log_file for details."
            exit 1
        fi
    else
        info "'$tool' is already installed."
    fi
}

install_tool "ccat" "..$ROOT_DIR/utils/scripts/install_ccat.sh" "$LOG_FILE"
install_tool "glow" "..$ROOT_DIR/utils/scripts/install_glow.sh" "$LOG_FILE"
install_tool "jq" "..$ROOT_DIR/utils/scripts/install_jq.sh" "$LOG_FILE"
install_tool "node" "..$ROOT_DIR/utils/scripts/install_node.sh" "$LOG_FILE"

if [ ! -f "$HOME/bin/z.sh" ]; then
    info "'z' is not installed. Proceeding with installation..."
    download_file "https://raw.githubusercontent.com/rupa/z/master/z.sh" "$HOME/bin/z.sh" "$LOG_FILE"
    chmod +x "$HOME/bin/z.sh"
else
    info "'z' is already installed"
fi

h2 "Updating 'bash' completion"
rm -rf "$HOME"/.bash_completion.d 2>/dev/null

if [ ! -f "$BASH_D/git" ]; then
    info "Updating 'bash' completion scripts for Git ..."
    download_file "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash" "$BASH_D/git" "$LOG_FILE"
    source "$BASH_D/git"
else
    info "Git completion script already exists."
fi

if [ ! -f "$BASH_D/npm" ]; then
    info "Updating 'bash' completion scripts for NPM ..."
    download_file "https://raw.githubusercontent.com/npm/cli/master/lib/utils/completion.sh" "$BASH_D/npm" "$LOG_FILE"
    source "$BASH_D/npm"
else
    info "NPM completion script already exists."
fi

gitconfig(){

    local personal_details_file="$HOME/.gitconfig-personal"
    local git_name=$(git config --global user.name || :)
    local git_email=$(git config --global user.email || :)
   
    debug "Git user.name: $git_name"
    debug "Git user.email: $git_email"

    if [[ -e "$personal_details_file" ]]; then
        debug "Found personal details file for Git. Re-using."

    else
        info "Creating personal details file for Git ($personal_details_file)"

        while [[ -z "$git_name" ]]; do
          debug "No committer name set in the global gitconfig."
          read -r -p "Input the name to be used by Git in your commits (e.g. \"John Doe\"): " git_name
        done

        while [[ -z "$git_email" ]]; do
          debug "No committer email set in the global gitconfig."
          read -r -p "Input the email to be used by Git in your commits (e.g. \"john.doe@google.com\"): " git_email
        done

        if [[ -z "$git_email" || -z "$git_name" ]]; then
            error "Both email and name must be specified"
            exit 1
        fi

        if [[ ! -f "./git-personal.template" ]]; then
            error "Git personal template 'git-personal.template' not found!"
            exit 1
        fi

        GIT_NAME=$git_name GIT_EMAIL=$git_email envsubst < ./git-personal.template > "$personal_details_file"
       
    fi

    info "Git user.name: $(git config user.name)"
    info "Git user.email: $(git config user.email)"
       
}

h2 "Linking files"
files=(
    "gitconfig"
    "profile"
    "bashrc"
    "gitignore_global"
    "tmux.conf"
    "tool-versions"
    "zshrc"
    "dependencies"
    "pystartup"
)

for file in "${files[@]}"; do
    ln -sf "$SCRIPT_DIR/$file" "$HOME/.$file"
    info "Symbolic link created: $HOME/$(basename ."$file") -> $SCRIPT_DIR/$file"
done

for file in "$SCRIPT_DIR"/bash.d/*; do
  ln -sf "$file" "${BASH_DIR}"/
  info "Symbolic link created: $BASH_DIR/$(basename ."$file") -> $file"
done

for file in "$ROOT"/utils/scripts/*; do
  ln -sf "$file" "${HOME}"/bin
  info "Symbolic link created: $HOME/bin/$(basename ."$file") -> $file"
done


ln -s "$SCRIPT_DIR/bash_completion.d" "$HOME/.bash_completion.d"
info "Symbolic link created: $HOME/.bash_completion.d -> $SCRIPT_DIR/bash_completion.d"

h2 "Configuring 'git'"
gitconfig

h2 "Configuring 'tmux'"
[[ ! -e "$HOME/.tmux" ]] && mkdir "$HOME/.tmux";
[[ ! -e "$HOME/.tmux/plugins" ]] && mkdir "$HOME/.tmux/plugins";
[[ ! -e "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME"/.tmux/plugins/tpm &>/dev/null

for file in "$SCRIPT_DIR"/tmux/*; do
  ln -sf "$file" "${HOME}/.tmux/"
  info "Symbolic link created: $HOME/.tmux/$(basename ."$file") -> $file"
done

h2 "Configuring 'allowed_signers'"
[[ ! -e ~/.ssh ]] && mkdir -m 700 ~/.ssh
rm -f ~/.ssh/allowed_signers 2>/dev/null
if [[ -e ./allowed_signers ]]; then
    
    ln -sf "$SCRIPT_DIR"/allowed_signers "$HOME"/.ssh/allowed_signers
    info "Symbolic link created: $HOME/.ssh/allowed_signers -> $SCRIPT_DIR/allowed_signers"
else
    info "Error: The 'allowed_signers' file is not present in the current directory."
    exit 1
fi

h1 "Finished common setup"
popd > /dev/null
