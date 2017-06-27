ruby_block 'fix dashboard static assets' do
  block do
    fe = Chef::Util::FileEdit.new('/etc/apache2/sites-enabled/openstack-dashboard.conf')
    fe.search_file_replace('/usr/share/openstack-dashboard/static', '/var/lib/openstack-dashboard/static')
    fe.write_file
  end
  only_if "cat /etc/apache2/sites-enabled/openstack-dashboard.conf | grep /usr/share/openstack-dashboard/static"
end
