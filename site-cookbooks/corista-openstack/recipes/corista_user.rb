# Install basic packages
package 'openssh-server'

# Give passwordless sudo
file '/etc/sudoers.d/corista' do
  content <<-EOF.trim_block
    # corista user sudo no passwd
    corista ALL=(ALL) NOPASSWD:ALL
  EOF
  mode '0440'
  owner 'root'
  group 'root'
end

# Initialize an ssh key and .ssh folder
id_rsa = '/home/corista/.ssh/id_rsa'
execute 'create ssh key' do
  command "ssh-keygen -f #{id_rsa} -t rsa -b 2048 -C 'node@openstack' -N ''"
  creates id_rsa
  user 'corista'
  group 'corista'
end

# Set up authorized_keys file for easy access
cookbook_file '/home/corista/.ssh/authorized_keys' do
  source 'openstack_cluster.pub'
  owner 'corista'
  group 'corista'
  mode '0600'
end
