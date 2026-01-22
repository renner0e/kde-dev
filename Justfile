[private]
default:
    @just --choose

# moves Wayland session file for development so you can login with SDDM/PLM

# If your system is sensible then /usr/local is writable, even on image based systems
session:
    #!/usr/bin/env bash
    set -eou pipefail
    if [ "$(systemd-detect-virt)" != "none" ]; then
      echo "Run this script only on the host. This won't work inside a container!"
      exit 1
    fi

    if ! podman container exec kde-dev test -f /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop; then
      printf "/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop does not exist in the KDE development container distrobox. You probably need to run kde-builder plasma-desktop (again)."
        exit 1
    fi

    podman container cp kde-dev:/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop /tmp
    mkdir -p $HOME/.local/bin
    sudo mkdir -p /usr/local/share/wayland-sessions
    sudo mv /tmp/plasmawayland-dev6.desktop /usr/local/share/wayland-sessions
    sudo chown root:root /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop

    # Selinux strikes again! This would show up as blank otherwise in SDDM <3
    if command -v selinuxenabled >/dev/null 2>&1 && selinuxenabled; then
      sudo restorecon -v /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop
    fi

    echo "Complete! Log out to see the Plasma development session in SDDM"

alias install-kde-development-session := session
