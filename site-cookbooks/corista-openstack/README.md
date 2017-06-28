# corista-openstack
Provides recipes that patch or add to [`openstack/cookbook-openstack-*`](https://github.com/openstack?q=cookbook-openstack-) cookbooks.

# recipes
__in progress__

## corista-openstack::corista_user
* sets up some convenience stuff for the default user `corista`

## corista-openstack::disable_network_manager
* disable NetworkManager from desktop versions of Ubuntu

## corista-openstack::setup_interfaces
* takes `node['corista-openstack'][:networks]` attribute and sets up physical networks.

## corista-openstack::horizon
* wraps `openstack-cookbook-dashboard::horizon` to fix configuration items.
