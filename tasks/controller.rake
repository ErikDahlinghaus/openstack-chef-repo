# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# client opts for the controller node
unless defined? CONTROLLER_CLIENT_OPTS
  CONTROLLER_CLIENT_OPTS = "--force-formatter --no-color -z --config #{CHEF_REPO_DIR}/.chef/controller_node.rb".freeze
end

# a list of roles from roles/corista-openstack-controller-*.rb that we want to execute for a controller node
unless defined? CONTROLLER_ROLES
  CONTROLLER_ROLES = %w(interfaces common identity)
end

# Sources ENV from /root/openrc before running cmd
def run_with_openrc(cmd)
  env = ::File.readlines('/root/openrc')
            .select { |l| l =~ /export / }
            .map { |l| l.gsub('export ','').chomp }
            .map { |l| l.split('=') }.to_h
  ENV.update(env)
  shell_out!(cmd)
end

# Tasks in the controller namespace install controller components and perform smoke tests
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
    result = 0
    [
      'netstat -tulpn | grep 5000 | grep 0.0.0.0',
      'openstack project list'
    ].each do |t|
      result += run_with_openrc(t)
    end
    puts "ERROR! One or more tests has a non-zero return status" unless result == 0
  end
end
