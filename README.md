# openstack-chef-repo
Derived from: https://github.com/ErikDahlinghaus/openstack-chef-repo

# Prereqs
This whole project depends on a fresh install of Ubuntu 16 (server or desktop) and the default user set up as `corista`.

# Getting started
* Be `root` so you can break the system.
  - `sudo -s`
* Install ChefDK.
  - Make sure you get the older 1.2 version with chef-client 12 for now.
* Git this repo to `/opt/corista/openstack-chef-repo`
* Go there `cd /opt/corista/openstack-chef-repo`
* Vendor the cookbooks
  - `chef exec rake vendor_cookbooks`
* Prepare this host for openstack install (run on all hosts)
  - `chef exec rake prepare_host`
* Check components for installation / test
  - `chef exec rake -T`

## Example controller node
```
chef exec rake vendor_cookbooks
chef exec rake prepare_host
chef exec rake controller:interfaces
chef exec rake controller:common
chef exec rake controller:identity
chef exec rake controller:identity_test
chef exec rake controller:image
chef exec rake controller:image_test
```

# Editing attributes
See `environments/corista-openstack-controller.json`
