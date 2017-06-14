service 'NetworkManager' do
  action [:stop, :disable]
  only_if { ::File.exist? '/lib/systemd/system/NetworkManager.service' }
end
