#!/bin/sh

set -oux pipefail

# Update the container and install packages
dnf upgrade -y
grep -v '^#' ./fedora.packages | xargs dnf install -y

dnf copr enable -y atim/starship
dnf copr disable -y atim/starship
dnf -y install --enablerepo="copr:copr.fedorainfracloud.org:atim:starship" starship
# This sets up the actual kde dev environment

dnf install -y git python3-dbus python3-pyyaml python3-setproctitle
git clone https://invent.kde.org/sdk/kde-builder.git /usr/share/kde-builder
ln -sf /usr/share/kde-builder/kde-builder /usr/bin/
cd /usr/share/kde-builder
pip install pipenv

yes | kde-builder --install-distro-packages
dnf builddep plasma-workspace -y
