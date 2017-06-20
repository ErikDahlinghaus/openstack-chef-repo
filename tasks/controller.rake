# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# Tasks in the controller namespace install controller components or perform smoke tests
namespace :controller do
  desc 'run chef-client in local-mode to install corista-openstack controller components'
  task :install do |t, args|
    run_role('corista-openstack-controller')
  end
end
