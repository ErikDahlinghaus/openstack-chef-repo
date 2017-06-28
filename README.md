# openstack-chef-repo
Derived from: https://github.com/openstack/openstack-chef-repo

This cookbook uses chef-client in solo mode to install components for openstack on various nodes. We encapsulate the configuration of the entire openstack system in [`environments/corista-openstack.json`](environments/corista-openstack.json). We describe our nodes and override necessary configuration in `roles/`. NOTE! The environment overrides the attribute from the role, so care must be taken when setting environment attributes. Currently we operate two nodes, a [controller](roles/corista-openstack-controller.json) node and a [compute1](roles/corista-openstack-compute1.json) node. We use [`sites-cookbooks/corista-openstack`](site-cookbooks/corista-openstack/README.md) to patch things in the existing `cookbook-openstack-*` cookbooks or add functionality.

# Prereqs
Two nodes with at least two NICs. A fresh install of Ubuntu 16 server, and a default user named `corista`. Hostnames of the machines should be `controller`, and `compute1` respectively.

# Getting started
On each node from a local terminal run the following commands.

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
* Check which tasks are available
  - `chef exec rake -T`
* Install components for a controller node
  - `chef exec rake controller:install`

# Development
Have a look at [`Berksfile`](Berksfile), [`Rakefile`](Rakefile), and [`site-cookbooks/corista-openstack/README.md`](site-cookbooks/corista-openstack/README.md).
