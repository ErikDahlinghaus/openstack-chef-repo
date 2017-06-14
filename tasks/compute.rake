# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# client opts for the controller node
unless defined? COMPUTE_CLIENT_OPTS
  COMPUTE_CLIENT_OPTS = [
    '--force-formatter',
    '--no-color',
    '-z',
    "--config #{CHEF_REPO_DIR}/.chef/compute_node.rb",
    '-E corista-openstack-compute'
  ].join(' ').freeze
end

# a list of roles from roles/corista-openstack-compute-*.rb that we want to execute for a compute node
unless defined? COMPUTE_ROLES
  COMPUTE_ROLES = %w(interfaces).freeze
end

# a list of commands that will be run when you call `rake compute:<component>_test`
unless defined? COMPUTE_TESTS
  COMPUTE_TESTS = {
  }.freeze
end

# Tasks in the controller namespace install compute components and perform smoke tests
namespace :compute do
  COMPUTE_ROLES.each do |name|
    # Creates a task to run chef-client on localhost to install the various components
    task_name = name.to_sym
    role_to_run = "corista-openstack-compute-#{name}"
    desc "executes chef-client to apply role[#{role_to_run}] on localhost"
    task task_name do |t, args|
      run_role(role_to_run, client_opts: COMPUTE_CLIENT_OPTS)
    end

    # Creates a task for testing if commands are provided above in CONTROLLER_TESTS
    tests = COMPUTE_TESTS[name.to_sym]
    unless tests.nil? || tests.empty?
      desc "executes the smoke tests for #{name}"
      task [name, '_test'].join do |t, args|
        run_smoke_tests(tests)
      end
    end
  end
end
