include_recipe 'openstack-dashboard::horizon'
include_recipe 'openstack-dashboard::compile_dashboard_assets'

require 'pp'

local_settings_path = node['openstack']['dashboard']['local_settings_path']
local_settings_template = nil
begin
  local_settings_template = resources(template: local_settings_path)
  r.cookbook('corista-openstack')
rescue Chef::Exceptions::ResourceNotFound => e
  puts "\n\n\n\n"
  puts "RESOURCE NOT FOUND template[#{local_settings_path}]"
  puts "\n\n\n\n"
  pp e
  puts "\n\n\n\n"
end

puts "\n\n\n\n"
pp "#{local_settings_template.variables}"
puts "\n\n\n\n"

raise StandardError, "Stopping run"
