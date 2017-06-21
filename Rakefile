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

desc "run recipe"
task :run_recipe, [:recipe] do |t, args|
  run_recipe(args[:recipe])
end

desc "run role"
task :run_role, [:role] do |t, args|
  run_role(args[:role])
end
