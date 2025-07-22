# kde-dev container based on Fedora

This includes all build dependencies of kde-builder and kde-builder itself and has tools I personally like, like `ripgrep`, `zsh`, `git`, `neovim`, `starship`

This instantly autostarts as it also includes all the stuff that distrobox wants

You still need `kde-builder` on the host in `~/.local/bin` for for all this to work

Do this one time on your host to setup kde-builder:

```
cd ~
curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > initial_setup.sh
bash initial_setup.sh
```


Setup the distrobox:

```
distrobox assemble create --file ./distrobox.ini
```

in the distrobox:

```
kde-builder plasma-workspace
```

on the host:

```
just session
```
