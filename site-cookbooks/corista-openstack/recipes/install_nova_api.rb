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

service 'nova-api' do
  service_name platform_options['compute_api_service']
  supports status: true, restart: true
  action [:enable, :start]
  subscribes :restart, 'template[/etc/nova/nova.conf]'
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
