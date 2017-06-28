# Common rake stuff
require_relative 'tasks/common'
include CoristaOpenStack::RakeCommon

# Import other tasks with .rake extension
Dir.glob('tasks/*.rake').each { |r| import r }

# Vendor cookbooks
desc "Vendor cookbooks"
task :berks_vendor do
  chef_exec('berks vendor cookbooks')
end

# Helper to run specific recipe
desc "run recipe"
task :run_recipe, [:recipe] do |t, args|
  run_recipe(args[:recipe])
end

# Helper to run specific role
desc "run role"
task :run_role, [:role] do |t, args|
  run_role(args[:role])
end

# Create a namespace and install task for each role
available_roles.each do |role_name|
  namespace_sym = role_name.sub(/^corista-openstack-/, '').to_sym
  namespace namespace_sym do
    desc "runs chef-client -z role[#{role_name}]"
    task :install do
      run_role(role_name)
    end
  end
end
