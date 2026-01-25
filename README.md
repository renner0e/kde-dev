# KDE Plasma build container

# What is this?

This container (to be used with Distrobox) includes all build dependencies to get a graphical development session of KDE Plasma running using [kde-builder](https://kde-builder.kde.org/).
This is especially nice for image based systems like Fedora Kinoite and Bazzite. But this also works on traditional systems of course.

# Prerequsities
- bash
- curl
- recent enough version of docker/podman (to support [zstd:chunked](https://www.redhat.com/en/blog/faster-container-image-pulls) containers)
- [distrobox](https://distrobox.it/)

This also has a couple additional handy tools:

- `git`
- `neovim`
- `ripgrep`
- `starship`
- `zsh`

The container is a little bit chunky and is around 10GiB big. But updates with `podman pull ghcr.io/renner0e/kde-dev:latest` should be manageable.

Do this one time on your host to setup `kde-builder`:

```
cd ~
curl 'https://invent.kde.org/sdk/kde-builder/-/raw/master/scripts/initial_setup.sh?ref_type=heads' > initial_setup.sh
bash initial_setup.sh
```

```
git clone https://github.com/renner0e/kde-dev && cd kde-dev
```

Setup the distrobox:

```
distrobox assemble create --file ./distrobox.ini
```

You may also do this manually with the `distrobox create`

```
distrobox enter kde-dev
```

Create kde-builder default config (only once)
```
kde-builder --generate-config
```

in the distrobox:

```
kde-builder plasma-desktop
```

on the host:

This will install a session file into `/usr/local/share/wayland-sessions`

```
just session
```

This should be all, now you can log out and select Plasma Development session in SDDM.

<img width="2141" height="732" alt="image" src="https://github.com/user-attachments/assets/afabcf3e-ddfd-4038-9aa7-96822fea6c13" />

