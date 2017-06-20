# Common rake stuff
require_relative 'tasks/common'
include CoristaOpenStack::RakeCommon

Dir.glob('tasks/*.rake').each { |r| import r }

desc "Create validator.pem"
task :create_key do
  if not ::File.exist?(::File.join(CHEF_REPO_DIR, '.chef/validator.pem'))
    require 'openssl'
    ::File.binwrite('.chef/validator.pem', OpenSSL::PKey::RSA.new(2048).to_pem)
  end
end

desc "Vendor your cookbooks"
task :berks_vendor do
  chef_exec('berks vendor cookbooks')
end

desc "Prepares host with basic functionality. Runs role corista-openstack-default"
task :prepare_host do
  run_role('corista-openstack-default')
end

desc "run recipe"
task :run_recipe, [:recipe] do |t, args|
  run_recipe(args[:recipe])
end
