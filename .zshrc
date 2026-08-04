export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export EDITOR=vim
export VISUAL=vim

alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gd='git diff'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Overrides locales, no versionados en este repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
