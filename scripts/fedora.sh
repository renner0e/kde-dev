#!/bin/sh

# Update the container and install packages
dnf upgrade -y
grep -v '^#' ./fedora.packages | xargs dnf install -y


# This sets up the actual kde dev environment

dnf install -y git python3-dbus python3-pyyaml python3-setproctitle
git clone https://invent.kde.org/sdk/kde-builder.git /usr/share/kde-builder
ln -sf /usr/share/kde-builder/kde-builder /usr/bin/
cd /usr/share/kde-builder
pip install pipenv

yes | kde-builder --install-distro-packages
