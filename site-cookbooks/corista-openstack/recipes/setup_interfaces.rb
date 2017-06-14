package 'bridge-utils'

template '/etc/network/interfaces' do
  source 'etc_network_interfaces.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

service 'networking' do
  action :restart
end
