#!/bin/bash

# root check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# upgrade system
apt update && apt -y dist-upgrade

# download chefdk
cd /tmp
DEB_PACKAGE="chefdk_1.2.22-1_amd64.deb"
if [ -f "$DEB_PACKAGE" ]; then
  rm "$DEB_PACKAGE"
fi
wget "https://packages.chef.io/files/stable/chefdk/1.2.22/ubuntu/16.04/$DEB_PACKAGE"

# install chefdk
dpkg -i "$DEB_PACKAGE"
apt install -f
