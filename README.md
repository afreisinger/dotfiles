# dotfiles

Dotfiles que requieren un symlink a `$HOME` (git y tmux).

> zsh y nvim no están acá: viven en sus propios repos con clone directo
> en el directorio XDG correspondiente.

## Dónde vive cada cosa

| Herramienta | Repo | Destino |
|-------------|------|---------|
| zsh + starship | [afreisinger/zsh](https://github.com/afreisinger/zsh) | `~/.config/zsh` (ZDOTDIR) |
| neovim (LazyVim) | [afreisinger/nvim](https://github.com/afreisinger/nvim) | `~/.config/nvim` |
| git, tmux, tmuxinator | **este repo** | symlinks a `$HOME` |

## Por qué este repo solo lleva git y tmux

`git`, `tmux` y `tmuxinator` no soportan XDG (`XDG_CONFIG_HOME`) para
reubicar su config. Buscan sus archivos en `$HOME` sí o sí:

- `~/.gitconfig`
- `~/.tmux.conf`
- `~/.config/tmuxinator/*.yml`

Por eso se clonan acá y se symlinkean a `$HOME`.

## Uso con el playbook (recomendado)

```bash
cd ubuntu-dotfiles-ansible
ansible-playbook main.yml -K --tags "dotfiles"
```

El rol `dotfiles` clona/actualiza este repo en `~/.dotfiles` y arma los
symlinks.

## Uso manual (sin ansible)

```bash
git clone https://github.com/afreisinger/dotfiles.git ~/.dotfiles

for f in .gitconfig .tmux.conf .gitignore_global; do
  ln -sf "$HOME/.dotfiles/$f" "$HOME/$f"
done

mkdir -p ~/.config/tmuxinator
ln -sf "$HOME/.dotfiles/.config/tmuxinator/dev.yml" "$HOME/.config/tmuxinator/dev.yml"
```

## Editar

Los archivos en `$HOME` son symlinks a este repo. Los editás directo donde
los usás; para guardar el cambio:

```bash
cd ~/.dotfiles
git add -A
git commit -m "ajustar tmux.conf"
git push
```

Si volvés a correr el playbook con cambios sin commitear acá, la tarea de
clonado falla a propósito (en vez de pisarte el trabajo) hasta que comitees.

## Contenido

| Archivo | Qué es |
|---------|--------|
| `.gitconfig` | Nombre/email, aliases, defaults de git |
| `.tmux.conf` | Prefix `C-a`, keybindings y plugins de tmux (TPM) |
| `.gitignore_global` | Ignores globales de git |
| `.config/tmuxinator/dev.yml` | Layout del workspace `dev` (tmuxinator) |