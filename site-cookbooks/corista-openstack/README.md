# corista-openstack

Provides simple recipes for use in roles to facilitate an openstack deploy.

# recipes

## corista-openstack::corista_user
* sets up some convenience stuff for the default user `corista`

## corista-openstack::disable_network_manager
* disable NetworkManager from desktop versions of Ubuntu

## corista-openstack::setup_interfaces
* takes `node['corista-openstack'][:networks]` attribute and sets up physical networks.

## corista-openstack::setup_db
* wrapper for `openstack-ops-database::server` to fix issue with `mysql_service` resource and grant privs for `root@%`
