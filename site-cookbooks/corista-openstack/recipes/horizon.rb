include_recipe 'openstack-dashboard::horizon'

local_settings_path = node['openstack']['dashboard']['local_settings_path']
begin
  # Use our cookbook's version of the local_settings.py.erb
  local_settings_template = resources(template: local_settings_path)
  local_settings_template.cookbook('corista-openstack')
rescue Chef::Exceptions::ResourceNotFound => e
  Chef::Log.error "RESOURCE NOT FOUND template[#{local_settings_path}]"
end

include_recipe 'corista-openstack::compile_dashboard_assets'
