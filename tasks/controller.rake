# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# client opts for the controller node
unless defined? CONTROLLER_CLIENT_OPTS
  CONTROLLER_CLIENT_OPTS = "--force-formatter --no-color -z --config #{CHEF_REPO_DIR}/.chef/controller_node.rb".freeze
end

# a controlled list of roles from roles/corista-openstack-controller-*.rb that we want to execute for a controller node
unless defined? CONTROLLER_ROLES
  CONTROLLER_ROLES = %w(interfaces common identity)
end

namespace :controller do
  # Runs chef roles on localhost to install the various components
  CONTROLLER_ROLES.each do |name|
    task_name = name.to_sym
    role_to_run = "corista-openstack-controller-#{name}"

    desc "executes chef-client to apply role[#{role_to_run}] on localhost"
    task task_name do |t, args|
      run_role(role_to_run, client_opts: CONTROLLER_CLIENT_OPTS)
    end
  end

  # Task to run all the controller install steps in order
  desc 'runs all controller install steps in order'
  task :all do |t, args|
    CONTROLLER_ROLES.each do |name|
      Rake::Task["controller:#{name}"].invoke
    end
  end

  # Simple tests to verify identity service is operating
  desc 'runs the identity service tests'
  task :identity_test do |t, args|
    shell_out!("openstack project list")
  end
end
