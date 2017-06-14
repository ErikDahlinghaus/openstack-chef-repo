include_recipe "openstack-ops-database::server"

# Fix MySQL cookbook to use systemd instead of upstart
begin
  r = resources(service: "default apparmor")
  r.provider(Chef::Provider::Service::Systemd)
rescue Chef::Exceptions::ResourceNotFound
  puts "\n\n\n\nERROR COULD NOT MODIFY MYSQL RESOURCE\n\n\n\n"
end

class ::Chef::Recipe # rubocop:disable Documentation
  include ::Openstack
end

# Grant privs to root on all networks
super_password = get_password 'db', node['openstack']['db']['root_user_key']
allow_remote_root = "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{super_password}' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mysql_cli_cmd = "mysql -h127.0.0.1 -uroot -p#{super_password} -e \"#{allow_remote_root}\""

execute 'Create root@% mysql user' do
  command mysql_cli_cmd
  user 'root'
end
