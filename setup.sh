#!/bin/sh

set -oux pipefail

dnf upgrade -y
grep -v '^#' ./packages.list | xargs dnf install -y

# This sets up the actual kde dev environment
dnf install -y git python3-dbus python3-pyyaml python3-setproctitle
git clone https://invent.kde.org/sdk/kde-builder.git /usr/share/kde-builder
ln -sf /usr/share/kde-builder/kde-builder /usr/bin/
cd /usr/share/kde-builder
pip install pipenv

yes | kde-builder --install-distro-packages

# Mostly to get optional deps in and occasional build errors caused by missing deps
dnf builddep -y \
  appstream \
  kf6-attica \
  kf6-kfilemetadata \
  kf6-ktexteditor \
  kf6-solid \
  kf6-sonnet \
  plasma-desktop \
  powerdevil

dnf copr enable -y atim/starship
dnf copr disable -y atim/starship
dnf -y install --enablerepo="copr:copr.fedorainfracloud.org:atim:starship" starship
