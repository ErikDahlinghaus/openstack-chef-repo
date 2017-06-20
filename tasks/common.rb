# monkey patch trim_block for block strings
class String
  def trim_block
    gsub(/^\s+/, '')
  end
end

module CoristaOpenStack
  # Common methods used in our rake tasks
  module RakeCommon
    # Locate chef-repo TLD
    unless defined? CHEF_REPO_DIR
      CHEF_REPO_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')).freeze
    end

    # default chef-client opts
    unless defined? CHEF_CLIENT_OPTS
      CHEF_CLIENT_OPTS = [
        '--force-formatter',
        '--no-color',
        '-z',
        "--config #{CHEF_REPO_DIR}/.chef/knife.rb",
        "-E corista-openstack"
      ].join(' ').freeze
    end

    # Shell out a command to be run in chef context
    def chef_exec(command)
      sh %(chef exec #{command})
    end

    # Shell out to chef-client
    def chef_client(command, client_opts: CHEF_CLIENT_OPTS)
      chef_exec(%(chef-client #{client_opts} #{command}))
    end

    # Run a recipe with chef-client
    def run_recipe(recipe, client_opts: CHEF_CLIENT_OPTS)
      chef_client("-o '#{recipe}'", client_opts: client_opts)
    end

    # Run a role with chef-client
    def run_role(role, client_opts: CHEF_CLIENT_OPTS)
      chef_client("-o 'role[#{role}]'", client_opts: client_opts)
    end
  end
end
