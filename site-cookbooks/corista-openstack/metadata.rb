name 'corista-openstack'
maintainer 'Erik Dahlinghaus'
maintainer_email 'erik.dahlinghaus@corista.com'
description 'Helper cookbook openstack'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

depends 'openstack-common'
depends 'openstack-compute'
depends 'openstack-dashboard'
