execute 'compile dashboard assets' do
  cwd '/usr/share/openstack-dashboard'
  command './manage.py collectstatic && ./manage.py compress --force'
end
