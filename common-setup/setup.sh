#!/bin/bash
# Run to setup with ./setup.sh
BASH_DIR="${HOME}/.bash.d"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo $SCRIPT_DIR

set -e #exit on error
[[ ! -z $DEBUG ]] && set -x

# read local environment variables, like auth tokens
if [ -e "${HOME}/.secret" ]; then
  source "${HOME}/.secret"
fi

pushd "$SCRIPT_DIR" > /dev/null

ROOT="$SCRIPT_DIR/.."
source "$ROOT/shared.lib"

if [ ! -e "$BASH_DIR" ]; then
  mkdir "${BASH_DIR}"
fi

if [ ! -e "$HOME/bin" ]; then
  mkdir "${HOME}/bin"
fi

rm -rf "$HOME"/.bash_completion.d 2>/dev/null
"$SCRIPT_DIR/update-completion-scripts.sh"
ln -s "$SCRIPT_DIR"/bash_completion.d "$HOME"/.bash_completion.d 

if [ -e "$HOME/.bash_profile" ]; then
    info "We don't use .bash_profile to avoid trouble. Renaming to .bash_profile.bak"
    mv ~/.bash_profile{,.bak}
fi


carefully_replace_gitconfig(){
    h2 "Configuring Git ..."

    local personal_details_file="$HOME/.gitconfig-personal"
    local git_name=$(git config --global user.name || :)
    local git_email=$(git config --global user.email || :)

    debug "Git user.name: $git_name"
    debug "Git user.email: $git_email"

    if [[ -e "$personal_details_file" ]]; then
        debug "Found personal details file for Git. Re-using."
    else
        h3 "Creating personal details file for Git ($personal_details_file)"

        if [[ "" == "$git_name" ]]; then
            debug "No committer name set in the global gitconfig."
            read -r -p "Input the name to be used by Git in your commits (e.g. \"John Doe\"): " git_name
        fi
        if [[ "" == "$git_email" ]]; then
            debug "No committer email set in the global gitconfig."
            read -r -p "Input the email to be used by Git in your commits (e.g. \"john.doe@google.com\"): " git_email
        fi

        if [[ -z "$git_email" || -z "$git_name" ]]; then
            error "Both email and name must be specified"
            exit 1
        fi

        GIT_NAME=$git_name GIT_EMAIL=$git_email envsubst < ./git-personal.template > "$personal_details_file"
    fi

    ln -sf "$SCRIPT_DIR"/gitconfig "$HOME"/.gitconfig
}

ln -sf "$SCRIPT_DIR"/profile "$HOME"/.profile
ln -sf "$SCRIPT_DIR"/bashrc "$HOME"/.bashrc
ln -sf "$SCRIPT_DIR"/gitignore_global "$HOME"/.gitignore_global
ln -sf "$SCRIPT_DIR"/dir_colors "$HOME"/.dir_colors

ln -sf "$SCRIPT_DIR"/files "$HOME"/.files
#ln -sf "$SCRIPT_DIR"/pystartup "$HOME"/.pystartup
#ln -sf "$SCRIPT_DIR"/tmux.conf "$HOME"/.tmux.conf
#ln -sf "$SCRIPT_DIR"/p10k.zsh "$HOME"/.p10k.zsh
carefully_replace_gitconfig

# Zsh
ln -sf "$SCRIPT_DIR"/zshrc "$HOME"/.zshrc

# create needed dirs
[[ ! -e "$HOME/.config/tmux" ]] && mkdir "$HOME/.config/tmux";
#[[ ! -e "$HOME/.config/tmux/plugins" ]] && mkdir "$HOME/.config/tmux/plugins";
[[ ! -e "$HOME/.mackup" ]] && mkdir "$HOME/.mackup";
[[ ! -e "$HOME/.config/tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm 

# copy tmux project settings
 for file in "$SCRIPT_DIR"/mackup/*; do
   ln -sf "$file" "${HOME}/.mackup"
 done



source_dir="$SCRIPT_DIR/config"
target_dir="$HOME/.config"

find "$source_dir" -type d -print0 | while IFS= read -r -d '' dir; do
    new_dir="${dir/$source_dir/$target_dir}"
    mkdir -p "$new_dir"
    #echo "Analizando $dir"
    echo "Directorio creado: $new_dir"
    
    find "$dir" -type f ! -name ".DS_Store" -print0 | while IFS= read -r -d '' file; do
        rel_path="${file/$source_dir\//}"  # Ruta relativa del archivo
        new_file="$target_dir/$rel_path"
        new_file_dir=$(dirname "$new_file")
        mkdir -p "$new_file_dir"
        ln -sf "$file" "$new_file"
        echo "Enlace simbólico creado: $new_file"
    
     done
done



#find "$source_dir" -type f ! -name ".DS_Store" -exec sh -c 'ln -s "$0" "${HOME}/.config/$0"; echo "Enlace creado para $0"' {} \;

# find "$SCRIPT_DIR"/config/nvim -type d -exec mkdir -p "${HOME}/.config/nvim/{}" \;
# find "$SCRIPT_DIR"/config/nvim -type f -exec sh -c 'ln -s "$0" "${HOME}/.config/nvim/$0"; echo "Enlace creado para $0"' {} \;


#[[ ! -e "$HOME/.config/tmux" ]] && mkdir "$HOME/.config/tmux";
#[[ ! -e "$HOME/.config/tmux/plugins" ]] && mkdir "$HOME/.config/tmux/plugins";
#[[ ! -e "$HOME/.tmux" ]] && mkdir "$HOME/.tmux";
[[ ! -e "$HOME/.config/tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME"/.config/tmux/plugins/tpm 




for file in "$SCRIPT_DIR"/bash.d/*; do
  ln -sf "$file" "${BASH_DIR}"/
done

# Remove any existing symlink (or dir on mingw) - will fail if it is a dir
# rm -rf "$HOME"/.vim 2>/dev/null
# if [ ! -e "$HOME"/.vim ]; then  
#     ln -sf "$SCRIPT_DIR"/vim/dotvim "$HOME"/.vim
# fi

# ln -sf "$SCRIPT_DIR"/vim/vimrc "$HOME"/.vimrc

# # Checks out the Vundle submodule
# git submodule update --init --recursive

# h2 "Installing all VIM plugins"
# info "(might take some time the first time ... )"
# vim +PlugInstall +qall

# h2 "Vim Fugitive setup"
# vim -X -u NONE -c "helptags ~/.vim/plugged/vim-fugitive/doc" -c q

# # Needed for Typescript support in CoC and YCM using tsserver
# ts_cmd='npm install -g typescript'
# if which npm > /dev/null 2>&1 ; then
#     which tsc > /dev/null 2>&1 || bash -c "$ts_cmd"
# else
#     banner "Install NodeJS and run '$ts_cmd' to get TypeScript support in Vim"
# fi

# touch "$HOME"/.vimrc.local

# Install NeoVim config (we don't have to worry about XDG_CONFIG_HOME stuff
 #[[ ! -e "$HOME"/.config ]] && mkdir "$HOME/.config"
# rm -rf ~/.config/nvim 
# ln -sf ~/.vim ~/.config/nvim
# ln -sf ~/.vimrc ~/.config/nvim/init.vim

# # Install a better matcher for Ctrl-P
# if ! command_exists matcher; then 
#     if ! command_exists make; then 
#         banner "'make' is not installed. Rerun the setup after the per-machine setup completes)"
#     else
#         (cd matcher
#         make 
#         make install PREFIX=$HOME
#         cd ..) > /dev/null
#     fi
# fi

# Make a config file for ngrok, passing in the secret auth token
# [[ ! -e "$HOME"/.ngrok2 ]] && mkdir "$HOME/.ngrok2"
# NGROK_YML="$HOME/.ngrok2/ngrok.yml"
# rm "$NGROK_YML" 2> /dev/null || :;
# cat > "$NGROK_YML" << EOF
# ###############################################################
# ## WARNING: this file is auto-generated. See dotfiles repo   ##
# ###############################################################
# authtoken: ${NGROK_AUTHTOKEN:-'fill-NGROK_AUTHTOKEN-in-in-~/.secret'} 

# EOF
# cat $SCRIPT_DIR/ngrok.yml >> "$NGROK_YML"

# h2 "Copying psql config"
# ln -sf "$SCRIPT_DIR"/psqlrc $HOME/.psqlrc

# Download to latest to home dir
h2 "Fetching Jump Around"
curl -s https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/bin/z.sh
h2 "Finished common setup"

popd > /dev/null
