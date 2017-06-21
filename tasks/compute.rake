# Common rake stuff
require_relative 'common'
include CoristaOpenStack::RakeCommon

# Tasks in the controller namespace install compute components or perform smoke tests
namespace :compute do
  desc 'run chef-client in local-mode to install corista-openstack compute components'
  task :install do |t, args|
    run_role('corista-openstack-compute')
  end
end
