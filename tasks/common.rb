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
      CHEF_REPO_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    # default chef-client opts
    unless defined? CHEF_CLIENT_OPTS
      CHEF_CLIENT_OPTS = "--force-formatter --no-color -z --config #{CHEF_REPO_DIR}/.chef/knife.rb".freeze
    end

    # Shell out a command to be run in chef context
    def run_chef_command(command)
      if File.exist?('Gemfile.lock')
        sh %(bundle exec #{command})
      else
        sh %(chef exec #{command})
      end
    end

    # Shell out to chef-client
    def chef_client(command, client_opts: CHEF_CLIENT_OPTS)
      cmd_to_run = ['chef-client', client_opts, command].join(' ')
      run_chef_command(cmd_to_run)
    end

    # Run a role with chef-client
    def run_role(role, client_opts: CHEF_CLIENT_OPTS)
      chef_client("-o 'role[#{role}]'", client_opts: client_opts)
    end

    # Shell out to system to perform tests and such
    # using mixlib/shellout for a little more control over sh
    require 'mixlib/shellout'
    def shell_out!(cmd)
      command = Mixlib::ShellOut.new(cmd)
      puts "# #{cmd}"
      command.run_command
      output = ''
      output << command.stdout unless command.stdout.chomp.empty?
      output << command.stderr unless command.stderr.chomp.empty?
      puts output
      puts "\nProgram Exit Status: #{command.exitstatus}\n-----\n\n"
      command.exitstatus
    end
  end
end
