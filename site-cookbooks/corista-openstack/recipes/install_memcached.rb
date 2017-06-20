package 'install memcached' do
  package_name %w(memcached python-memcache)
end

ruby_block 'configure memcached' do
  block do
    # no-op
  end
end

service 'memcached' do
  action :nothing
end
