# openstack-chef-repo
Derived from: https://github.com/ErikDahlinghaus/openstack-chef-repo

# Prereqs
This whole project depends on a fresh install of Ubuntu 16 (server or desktop) and the default user set up as `corista`.

# Getting started
* Be `root` so you can break the system.
  - `sudo -s`
* Git this repo
  - `mkdir -p /opt/corista`
  - `cd /opt/corista`
  - `git clone git@github.com:ErikDahlinghaus/openstack-chef-repo.git`
* Go there
  - `cd /opt/corista/openstack-chef-repo`
* Install ChefDK.
  - `./install_chefdk.sh`
* Vendor the cookbooks
  - `chef exec rake berks_vendor`
* Prepare this host for openstack install (run on all hosts)
  - `chef exec rake prepare_host`
* Check components for installation / test
  - `chef exec rake -T`
