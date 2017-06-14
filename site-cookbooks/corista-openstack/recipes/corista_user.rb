sudoers_content = <<-EOF
# corista user sudo no passwd
corista ALL=(ALL) NOPASSWD:ALL
EOF

file '/etc/sudoers.d/corista' do
  content sudoers_content
  mode '0440'
  owner 'root'
  group 'root'
end
