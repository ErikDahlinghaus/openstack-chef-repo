# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# client opts for the controller node
unless defined? CONTROLLER_CLIENT_OPTS
  CONTROLLER_CLIENT_OPTS = [
    '--force-formatter',
    '--no-color',
    '-z',
    "--config #{CHEF_REPO_DIR}/.chef/controller_node.rb",
    '-E corista-openstack-controller'
  ].join(' ').freeze
end

# a list of roles from roles/corista-openstack-controller-*.rb that we want to execute for a controller node
unless defined? CONTROLLER_ROLES
  CONTROLLER_ROLES = %w(interfaces common identity image).freeze
end

# a list of commands that will be run when you call `rake controller:<component>_test`
unless defined? CONTROLLER_TESTS
  CONTROLLER_TESTS = {
    identity: [
      'netstat -tulpn | grep 5000 | grep 0.0.0.0',
      'openstack project list'
    ],
    image: [
      'openstack image list'
    ]
  }.freeze
end

# Tasks in the controller namespace install controller components and perform smoke tests
namespace :controller do
  CONTROLLER_ROLES.each do |name|
    # Creates a task to run chef-client on localhost to install the various components
    task_name = name.to_sym
    role_to_run = "corista-openstack-controller-#{name}"
    desc "executes chef-client to apply role[#{role_to_run}] on localhost"
    task task_name do |t, args|
      run_role(role_to_run, client_opts: CONTROLLER_CLIENT_OPTS)
    end

    # Creates a task for testing if commands are provided above in CONTROLLER_TESTS
    tests = CONTROLLER_TESTS[name.to_sym]
    unless tests.nil? || tests.empty?
      desc "executes the smoke tests for #{name}"
      task [name, '_test'].join do |t, args|
        run_smoke_tests(tests)
      end
    end
  end
end
