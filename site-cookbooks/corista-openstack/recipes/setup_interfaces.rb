package 'install networking packages' do
  package_name %w(bridge-utils vlan)
end

template '/etc/network/interfaces' do
  source 'etc_network_interfaces.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables interfaces: node['corista-openstack']['interfaces']
  notifies :restart, 'service[networking]', :immediately
end

service 'networking' do
  action :nothing
end
