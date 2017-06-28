include_recipe 'openstack-network'

require 'uri'

# Make Openstack object available in Chef::Recipe
class ::Chef::Recipe
  include ::Openstack
end

conf = node.default['openstack']['network_dns']['conf']

# keystone_authtoken
identity_admin_endpoint = admin_endpoint 'identity'
auth_url = ::URI.decode identity_admin_endpoint.to_s
conf['keystone_authtoken']['auth_host'] = identity_admin_endpoint.host
conf['keystone_authtoken']['auth_port'] = identity_admin_endpoint.port
conf['keystone_authtoken']['auth_protocol'] = identity_admin_endpoint.scheme

# get service user/pass
service_user = node['openstack']['network_dns']['conf']['keystone_authtoken']['admin_user']
service_pass = get_password 'service', 'openstack-dns'
conf['keystone_authtoken']['admin_password'] = service_pass

# storage:sqlalchemy
db_name = node['openstack']['db']['dns']['db_name']
db_user = node['openstack']['db']['dns']['username']
db_pass = get_password 'db', 'dns'
conf['storage:sqlalchemy']['connection'] = db_uri(db_name, db_user, db_pass)

# designate service info
service_role = node['openstack']['network_dns']['service_role']
service_name = node['openstack']['network_dns']['service_name']
service_tenant_name = node['openstack']['network_dns']['conf']['keystone_authtoken']['admin_tenant_name']
service_domain_name = node['openstack']['network_dns']['service_domain_name']
admin_service_role = node['openstack']['identity']['admin_domain_name']

# openstack api credentials
api_admin_user = node['openstack']['identity']['admin_user']
api_admin_pass = get_password 'user', node['openstack']['identity']['admin_user']
api_admin_project = node['openstack']['identity']['admin_project']
api_admin_domain = node['openstack']['identity']['admin_domain_name']
api_connection_params = {
  openstack_auth_url:     "#{auth_url}/auth/tokens",
  openstack_username:     api_admin_user,
  openstack_api_key:      api_admin_pass,
  openstack_project_name: api_admin_project,
  openstack_domain_name:    api_admin_domain
}

# Create designate user
openstack_user service_user do
  project_name service_tenant_name
  role_name admin_service_role
  password service_pass
  connection_params api_connection_params
end

# Grant Service role to Service User for Service Tenant ##
openstack_user service_user do
  project_name service_tenant_name
  role_name admin_service_role
  connection_params connection_params
  action :grant_role
end

openstack_user service_user do
  domain_name service_domain_name
  role_name admin_service_role
  connection_params connection_params
  action :grant_domain
end

# Create the designate service
openstack_service service_name do
  type 'dns'
end

# Create the designate enpoint
endpoint_url = public_endpoint 'dns'
endpoint_region = node['openstack']['region']
openstack_endpoint 'dns' do
  service_name service_name
  interface 'public'
  url endpoint_url.to_s
  region endpoint_region
  connection_params connection_params
end


#### actually configure the services

# install designate packages
platform_options = node['openstack']['network']['platform']
platform_options['neutron_dns_packages'].each do |pkg|
  package pkg do
    options platform_options['package_overrides']
    action :upgrade
  end
end

# # set up named.conf.options file
# template node['openstack']['network']['bind']['config_file'] do
#   source 'named.conf.options.erb'
#   node 00644
#   variables options: node['openstack']['network']['bind']['options']
# end

# # generate an rndc key
# gen_rndc_key_cmd = 'rndc-confgen -a -k designate -c /etc/designate/rndc.key'
# execute 'generate rndc key' do
#   user 'root'
#   command gen_rndc_key_cmd
# end












########################

nova_user = node['openstack']['compute']['user']
nova_group = node['openstack']['compute']['group']
execute 'nova-manage api_db sync' do
  timeout node['openstack']['compute']['dbsync_timeout']
  user nova_user
  group nova_group
  command 'nova-manage api_db sync'
  action :run
end

# register cell0 database
execute 'nova-manage cell_v2 map_cell0' do
  timeout node['openstack']['compute']['dbsync_timeout']
  user nova_user
  group nova_group
  command 'nova-manage cell_v2 map_cell0'
  action :run
end

# create cell1
execute 'nova-manage cell_v2 create_cell --name=cell1' do
  timeout node['openstack']['compute']['dbsync_timeout']
  user nova_user
  group nova_group
  command 'nova-manage cell_v2 create_cell --name=cell1'
  action :run
  not_if "nova-manage cell_v2 list_cells | grep cell1", user: nova_user, group: nova_group
end

# populate the nova database
execute 'nova-manage db sync' do
  timeout node['openstack']['compute']['dbsync_timeout']
  user nova_user
  group nova_group
  command 'nova-manage db sync'
  action :run
end


########################

service_config = merge_config_options 'network_dhcp'
template node['openstack']['network_dhcp']['config_file'] do
  source 'openstack-service.conf.erb'
  cookbook 'openstack-common'
  owner node['openstack']['network']['platform']['user']
  group node['openstack']['network']['platform']['group']
  mode 00644
  variables(
    service_config: service_config
  )
end

# TODO: (jklare) this should be refactored and probably pull in the some dnsmasq
# cookbook to do the proper configuration
case node['platform']
when 'centos'
  rpm_package 'dnsmasq' do
    action :upgrade
  end
end

service 'neutron-dhcp-agent' do
  service_name platform_options['neutron_dhcp_agent_service']
  supports status: true, restart: true
  action [:enable, :start]
  subscribes :restart, [
    'template[/etc/neutron/neutron.conf]',
    'template [/etc/neutron/dnsmasq.conf]',
    "template[#{node['openstack']['network_dhcp']['config_file']}]",
    'rpm_package[dnsmasq]'
  ]
end
