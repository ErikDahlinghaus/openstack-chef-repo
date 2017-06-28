# corista-openstack
This cookbook p
Provides simple recipes for use in roles to facilitate an openstack deploy.

# recipes

## corista-openstack::corista_user
* sets up some convenience stuff for the default user `corista`

## corista-openstack::disable_network_manager
* disable NetworkManager from desktop versions of Ubuntu

## corista-openstack::setup_interfaces
* takes `node['corista-openstack'][:networks]` attribute and sets up physical networks.

## corista-openstack::horizon
* wraps `openstack-cookbook-dashboard::horizon` to fix configuration items.
