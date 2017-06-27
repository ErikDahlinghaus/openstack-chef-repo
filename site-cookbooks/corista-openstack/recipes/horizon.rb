include_recipe 'openstack-dashboard::horizon'

require 'pp'

local_settings_path = node['openstack']['dashboard']['local_settings_path']
local_settings_template = nil
begin
  local_settings_template = resources(template: local_settings_path)
  local_settings_template.cookbook('corista-openstack')
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

include_recipe 'corista-openstack::compile_dashboard_assets'
