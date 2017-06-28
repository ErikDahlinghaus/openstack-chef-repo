# openstack-chef-repo
Derived from: https://github.com/openstack/openstack-chef-repo

This cookbook uses chef-client in solo mode to install components for openstack on various nodes. We encapsulate the configuration of the entire openstack system in [`environments/corista-openstack.json`](environments/corista-openstack.json). We describe our nodes and override necessary configuration in [`roles/`](roles).

**NOTE**! The environment overrides the attribute from the role, so care must be taken when setting environment attributes.

Currently we operate two nodes, a [controller](roles/corista-openstack-controller.json) node and a [compute1](roles/corista-openstack-compute1.json) node. We use [`sites-cookbooks/corista-openstack`](site-cookbooks/corista-openstack) to patch things in the existing `cookbook-openstack-*` cookbooks or add functionality.

# Prereqs
Two nodes with at least two NICs. A fresh install of Ubuntu 16 server, and a default user named `corista`. Hostnames of the machines should be `controller`, and `compute1` respectively.

# Getting started
__in progress__
## Each node
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

# Manual configuration steps
Perform these steps on the `controller` node. This will set up the openstack cluster for use using the openstack API through the `openstack` CLI.

## Projects, groups, roles, and users
First we create our default project where we will spawn most of our instances. Then we create a `developers` group which we will add regular users to. We create a role `developer` which can be assigned to things in the future. We associate the `developers` group with the `developer` and `admin` roles and the `corista` project. Now any user added to the `developers` group will become an admin on the `corista` project.

```sh
sudo -s

# source credentials for openstack client
source /root/openrc

# create corista project
openstack project create --or-show --enable --description "default corista project" corista

# create developers group
openstack group create --or-show --description "developers developers" developers

# add developer role (currently associated with nothing)
openstack role create --or-show developer

# associate developer role with developer group for the corista project
openstack role add --project corista --group developers developer

# associate admin role with developer group for the corista project
# * gives anyone in the developers group admin privileges on the corista project
openstack role add --project corista --group developers admin

# add the corista user, associated with the corista project
openstack user create --or-show --project corista --description "default corista user" corista

# add the corista user to the developers group
openstack group add user developers corista

# add other users and associate them with the developers group
export USER=syang
# add the $USER user, associated with the corista project
openstack user create --or-show --project corista $USER
# add the $USER user to the developers group
openstack group add user developers $USER
```

## Networks
__in progress__

# Development
Have a look at [`Berksfile`](Berksfile), [`Rakefile`](Rakefile), and [`site-cookbooks/corista-openstack/README.md`](site-cookbooks/corista-openstack/README.md).
