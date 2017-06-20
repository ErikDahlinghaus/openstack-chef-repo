package 'install memcached' do
  package_name %w(memcached python-memcache)
end

ip = node['corista-openstack']['controller_host']

ruby_block 'configure memcached' do
  block do
    # no-op
    fe = Chef::Util::FileEdit.new("/etc/memcached.conf")
    fe.search_file_replace_line('-l 127.0.0.1', "-l #{ip}")
    fe.write_file
  end
  not_if "cat /etc/memcached.conf | grep #{ip}"
end

service 'memcached' do
  action :nothing
end
