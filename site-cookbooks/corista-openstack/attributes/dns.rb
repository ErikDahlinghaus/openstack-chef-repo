# bind9 setup
default['openstack']['network']['bind']['config_file'] = '/etc/bind/named.conf.options'
default['openstack']['network']['bind']['options'] = {
  'allow-new-zones': 'yes',
  'request-ixfr': 'no',
  'recursion': 'no'
}

# Setup for network_dns
default['openstack']['network']['platform'].tap do |platform|
  platform['neutron_dns_packages'] = %w(bind9 designate designate-worker designate-producer designate-mdns)
  platform['neutron_dns_services'] = %w(designate-central designate-api designate-worker designate-producer designate-mdns)
end

# Set up default bind_service
default['openstack']['bind_service']['public']['dns'] = { host: '0.0.0.0', port: 9001 }

# Set up default endpoints
default['openstack']['endpoints']['public']['dns'] = { host: '127.0.0.1', port: 9001 }

# network_dns config options
default['openstack']['network_dns']['enabled'] = true
default['openstack']['network_dns']['service_name'] = 'designate'
default['openstack']['network_dns']['service_domain_name'] = 'default'
default['openstack']['network_dns']['config_file'] = '/etc/designate/designate.conf'
default['openstack']['network_dns']['conf_secrets'] = {}
default['openstack']['network_dns']['conf'].tap do |conf|
  # service:api section
  conf['service:api']['api_host'] = '0.0.0.0'
  conf['service:api']['api_port'] = 9001
  conf['service:api']['auth_strategy'] = 'keystone'
  conf['service:api']['enable_api_v1'] = true
#  conf['service:api']['enabled_extensions_v1'] = 'quotas, reports'
  conf['service:api']['enable_api_v2'] = true

  # keystone_authtoken section
  conf['keystone_authtoken']['admin_user'] = 'designate'
  conf['keystone_authtoken']['admin_tenant_name'] = 'service'

  # service:worker section
  conf['service:worker']['enabled'] = true
  conf['service:worker']['notify'] = true
end
