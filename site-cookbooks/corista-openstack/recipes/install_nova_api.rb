require 'uri'

class ::Chef::Recipe
  include ::Openstack
end

include_recipe 'openstack-compute::nova-common'

platform_options = node['openstack']['compute']['platform']

platform_options['compute_api_packages'].each do |pkg|
  package pkg do
    options platform_options['package_overrides']
    action :upgrade
  end
end

template '/etc/nova/api-paste.ini' do
  source 'api-paste.ini.erb'
  cookbook 'openstack-compute'
  owner node['openstack']['compute']['user']
  group node['openstack']['compute']['group']
  mode 00644
end

service 'nova-api' do
  service_name platform_options['compute_api_service']
  supports status: true, restart: true
  action [:enable, :start]
  subscribes :restart, [
    'template[/etc/nova/api-paste.ini]',
    'template[/etc/nova/nova.conf]'
  ]
end

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
