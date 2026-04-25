# KDE Plasma build container

# What is this?

This container (to be used with Distrobox) includes all build dependencies to get a graphical development session of KDE Plasma running using [kde-builder](https://kde-builder.kde.org/).
This is especially nice for image based systems like Fedora Kinoite and Bazzite.

But this also works on traditional systems to not mess up your host with unnecessary build dependencies.

# Prerequsities
- bash
- curl
- recent enough version of docker/podman (to support [zstd:chunked](https://www.redhat.com/en/blog/faster-container-image-pulls) containers)
- [distrobox](https://distrobox.it/)
- [just](https://github.com/casey/just)
- Quite a bit of storage space, for me all of `~/kde` takes up 67GB

This also has a couple additional handy tools:

- `git`
- `neovim`
- `ripgrep`
- `starship`
- `zsh`

The container is a little bit chunky and is ~3GiB big with compression. But updates with `podman pull ghcr.io/renner0e/kde-dev:latest` should be somewhat ok due to `zstd:chunked` partial pulls and chunkah[https://github.com/coreos/chunkah]. You can also update the container with `dnf upgrade`. It could be significantly trimmed down tho.

# Setup

```
git clone https://github.com/renner0e/kde-dev && cd kde-dev
```

Setup the distrobox:

```
distrobox assemble create --file ./distrobox.ini
```

You may also do this manually with the `distrobox create -i ghcr.io/renner0e/kde-dev:latest -n kde-dev` command

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

This will install a session file into `/usr/local/share/wayland-sessions`, make sure it's writable of course

```
just session
```

This should be all, now you can log out and select Plasma Development session in SDDM/PLM.
<img width="445" height="314" alt="image" src="https://github.com/user-attachments/assets/4a9998ac-2456-4a69-9207-dcf14a309ab2" />

<img width="1080" height="366" alt="image" src="https://github.com/user-attachments/assets/afabcf3e-ddfd-4038-9aa7-96822fea6c13" />

# Goodies

## Faster compile times

`just ccache` for convenience

Setting up `ccache` for super fast compile times - https://develop.kde.org/docs/getting-started/building/kde-builder-tips/#building-with-ccache-or-sccache

`ccache` is obviously already preinstalled.

[Download ccache used by KDE Linux](https://storage.kde.org/kde-linux-packages/testing/ccache/ccache.tar) and put it in `~/.cache/ccache`

directory structure should look like this:

```
❯ tree -d -L 1 .cache/ccache
.cache/ccache
├── 0
├── ...
├── f
└── lock
```

## How do I build this container locally?

Not with docker probably because we rely on the `"FROM oci-archive:` trick"

[See this](https://github.com/coreos/chunkah#splitting-an-image-at-build-time-buildahpodman-only)

```
buildah build --target base -t localhost/kde-dev . 
```

With rechunking:
```
buildah build -t localhost/kde-dev:latest --skip-unused-stages=false -v $(pwd):/run/src --security-opt=label=disable .
```

Change all the image refs to the one you chose instead of `ghcr.io/renner0e/kde-dev:latest`

## It's not compiling/crashing on start

- Probably just missing a library that hasn't been added to Fedora's .spec files or isn't installed here, find out and then install it with `dnf provides "*missing.so*"` or it's missing here, PR `dnf builddep failedproject`

- Linker issues, general build churn due to not clearing out `~/kde/build/project`, fixed by removing it, sometimes you might also want to nuke the relevant part or all of the `~/kde/usr` tree

- Crashes might be a symptom of a missing library as well (), could be that your host provides `example.so.3` but KWin or whatever was compiled with `example.so.4` which is not present in the `~/kde/usr` tree because the container has newer deps than your host, copy them to `~/kde/usr` I guess

# Remove/undo all changes

Remove session:

```
sudo rm /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop
```

Delete source code and filesystem tree:

See your `~/.config/kde-builder.yaml` for all directories.

```
rm -rf ~/kde/{usr,src,build}
```

Delete the container:

```
podman image rm -f ghcr.io/renner0e/kde-dev:latest
```

Delete kde-builder config:

```
rm -f ~/.config/kde-builder.yaml
```
