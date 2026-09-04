export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh-completions
  fzf-tab
)

source $ZSH/oh-my-zsh.sh

# p10k: corre `p10k configure` para regenerar el prompt, o edita ~/.p10k.zsh.
# Sin el archivo, p10k abre el wizard la primera vez que entras a zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export EDITOR=vim
export VISUAL=vim

# --- historial: compartido entre sesiones, sin duplicados ---
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# --- aliases de navegacion ---
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# --- aliases git (el plugin `git` de OMZ ya trae muchos: gst, ga, gaa, gcmsg, ...) ---
alias gs='git status'
alias glg='git log --oneline --decorate --graph --all'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf-tab: <TAB> completa con fzf. Preview del directorio en `cd`.
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls -1 --color=always $realpath'

# Overrides locales, no versionados en este repo
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
