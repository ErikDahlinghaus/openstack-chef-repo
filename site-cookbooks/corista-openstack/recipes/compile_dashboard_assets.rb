execute 'collect assets' do
  user 'root'
  cwd '/usr/share/openstack-dashboard'
  command './manage.py collectstatic'
  not_if 'test -d /var/lib/openstack-dashboard/static/dashboard/'
end

execute 'compress assets' do
  user 'root'
  cwd '/usr/share/openstack-dashboard'
  command './manage.py compress --force'
  not_if 'test -d /usr/share/openstack-dashboard/openstack_dashboard/templatetags/'
end
