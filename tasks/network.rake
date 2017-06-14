# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# client opts for the controller node
unless defined? NETWORK_CLIENT_OPTS
  NETWORK_CLIENT_OPTS = [
    '--force-formatter',
    '--no-color',
    '-z',
    "--config #{CHEF_REPO_DIR}/.chef/network_node.rb",
    '-E corista-openstack-network'
  ].join(' ').freeze
end

# a list of roles from roles/corista-openstack-network-*.rb that we want to execute for a network node
unless defined? NETWORK_ROLES
  NETWORK_ROLES = %w().freeze
end

# a list of commands that will be run when you call `rake network:<component>_test`
unless defined? NETWORK_TESTS
  NETWORK_TESTS = {
  }.freeze
end

# Tasks in the controller namespace install network components and perform smoke tests
namespace :controller do
  NETWORK_ROLES.each do |name|
    # Creates a task to run chef-client on localhost to install the various components
    task_name = name.to_sym
    role_to_run = "corista-openstack-network-#{name}"
    desc "executes chef-client to apply role[#{role_to_run}] on localhost"
    task task_name do |t, args|
      run_role(role_to_run, client_opts: NETWORK_CLIENT_OPTS)
    end

    # Creates a task for testing if commands are provided above in CONTROLLER_TESTS
    tests = NETWORK_TESTS[name.to_sym]
    unless tests.nil? || tests.empty?
      desc "executes the smoke tests for #{name}"
      task [name, '_test'].join do |t, args|
        run_smoke_tests(tests)
      end
    end
  end
end
