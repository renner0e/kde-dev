[private]
default:
    @just --choose

session:
    #!/usr/bin/bash
    if ! podman container exec kde-dev test -f /usr/local/share/wayland-sessions/plasmawayland-dev6.desktop; then
        printf "The file '/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop' does not exist in the KDE development container distrobox.\nYou will need to run ujust setup-kde-development-environment first.\n"
        exit 1
    fi
    printf "This will set up an overlayfs over /usr, making it temporarily mutable until the next reboot. This recipe will need to be run again on every reboot.\n"
    sudo bootc usroverlay
    echo 'chown -f -R $USER:$USER /tmp/.X11-unix' | sudo tee /etc/profile.d/set_tmp_x11_permissions.sh > /dev/null
    podman container cp kde-dev:/usr/local/share/wayland-sessions/plasmawayland-dev6.desktop ~/
    sed -i "s@^Exec=.*@Exec=$HOME/.local/bin/start-plasma-dev-session@" ~/plasmawayland-dev6.desktop
    sudo mv ~/plasmawayland-dev6.desktop /usr/share/wayland-sessions
    echo "$HOME/kde/usr/lib64/libexec/kactivitymanagerd & disown
    $HOME/kde/usr/lib64/libexec/plasma-dbus-run-session-if-needed $HOME/kde/usr/lib64/libexec/startplasma-dev.sh -wayland" > ~/.local/bin/start-plasma-dev-session
    chmod +x ~/.local/bin/start-plasma-dev-session
    printf "Complete! Log out to see the Plasma development session in SDDM.\n"

alias install-kde-development-session := session 
