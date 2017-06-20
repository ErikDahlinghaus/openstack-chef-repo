#!/bin/sh

sudo -s
apt update && apt -y dist-upgrade
cd /tmp
wget https://packages.chef.io/files/stable/chefdk/1.2.22/ubuntu/16.04/chefdk_1.2.22-1_amd64.deb
dpkg -i chefdk*.deb
apt install -f
