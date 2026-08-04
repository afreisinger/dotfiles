# dotfiles

Mis dotfiles personales: zsh (Oh My Zsh), git, tmux y vim/neovim.

Pensado para usarse junto con
[ubuntu-dotfiles-ansible](https://github.com/afreisinger/ubuntu-dotfiles-ansible):
el rol `dotfiles` de ese playbook clona este repo en `~/.dotfiles` y
symlinkea cada archivo a `$HOME` (`~/.zshrc -> ~/.dotfiles/.zshrc`, etc).

## Uso con el playbook (recomendado)

```bash
cd ubuntu-dotfiles-ansible
ansible-playbook main.yml -K --tags "dotfiles"
```

Esto clona/actualiza este repo y arma todos los symlinks.

## Uso manual (sin ansible)

```bash
git clone https://github.com/afreisinger/dotfiles.git ~/.dotfiles

for f in .zshrc .gitconfig .tmux.conf .vimrc .gitignore_global; do
  ln -sf "$HOME/.dotfiles/$f" "$HOME/$f"
done
```

## Editar

Como `$HOME/.zshrc` (y el resto) son symlinks a este repo, los editas
directo donde los uses normalmente. Cuando quieras guardar el cambio:

```bash
cd ~/.dotfiles
git add -A
git commit -m "ajustar zshrc"
git push
```

Si despues volves a correr el playbook de ansible con cambios sin
commitear en `~/.dotfiles`, la tarea de clonado va a fallar a proposito
(en vez de pisarte el cambio) hasta que comitees o hagas stash.

## Contenido

| Archivo             | Que es                                      |
|----------------------|----------------------------------------------|
| `.zshrc`             | Config de zsh + Oh My Zsh (tema, plugins, aliases) |
| `.gitconfig`         | Nombre/email, aliases, defaults de git       |
| `.tmux.conf`         | Prefix, keybindings y plugins de tmux (TPM)  |
| `.vimrc`             | Config de vim, tambien usada como `init.vim` de neovim |
| `.gitignore_global`  | Ignores globales de git                      |
