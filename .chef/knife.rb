# See http://docs.opscode.com/config_rb_knife.html
# for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level :info
log_location STDOUT
node_name 'openstack_node'
client_key "#{current_dir}/openstack_node.pem"
validation_client_name 'chef-validator'
validation_key "#{current_dir}/validator.pem"
chef_server_url 'https://localhost/organizations/corista'
cache_type 'BasicFile'
cache_options(path: "#{ENV['HOME']}/.chef/checksums")
cookbook_path ["#{current_dir}/../cookbooks",
               "#{current_dir}/../site-cookbooks"]
knife[:secret_file] = "#{current_dir}/encrypted_data_bag_secret"
