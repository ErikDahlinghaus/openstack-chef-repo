# generate a good password
def generate_password(name = '')
  # TODO: replace with a real password generator
  'mypass'.freeze
end

# generate a good token
def generate_token(name = '')
  # TODO: replace with a real token generator
  "#{name}_token"
end

# generate an https keypair for horizon
def generate_horizon_https_keypair(hostname = '')
  # TODO: Actually generate a keypair
  horizon_public_half = <<-EOH
-----BEGIN CERTIFICATE-----
MIICvjCCAaYCCQCnQkgewKj1UTANBgkqhkiG9w0BAQsFADAhMR8wHQYDVQQDDBZj
b250cm9sbGVyLmV4YW1wbGUuY29tMB4XDTE1MDUwNjAyMDUzN1oXDTI1MDUwMzAy
MDUzN1owITEfMB0GA1UEAwwWY29udHJvbGxlci5leGFtcGxlLmNvbTCCASIwDQYJ
KoZIhvcNAQEBBQADggEPADCCAQoCggEBAMPXV6JQB+IdFxc5YXI1NPlByHcDMPOb
vgjw8oaHlDyU3f0I89jmEntUP3Lb89rn6HdoyP120plISCvG5QQwLyiKA8/kN8F3
PWtONkSQftBgyEHzGwvvvVnh5Eq/g8U5uvZTItS54Fj7Cj/YzfQLVHA4U/TwnpZW
LK/CXLdTOEgfMhBE2vKfqoFCKHXcz1QB2gCcNukJtwdUUSxbEfebeCHV4Z3pgqzF
y8iP9AhEpZSqbfudPcBlQ03YvwNrpO6NY36FOWO4blqNCCtBZspuMd0MCMi1Nk0l
0nBaIgmde1pmlbZqPqQEW9glQkz5tW41iplJruCEc48Ri5u+1FmoNpECAwEAATAN
BgkqhkiG9w0BAQsFAAOCAQEAs38vH/ZxpdrvOFB5A3+/hXK6u7PHMKNgZRbE5jZv
j4HdTPLR+rQmI+Mrwu22N3ng0Nmhkl8GHvp5bQi+9KXAssCaSLjJaKMaDc6l1pRR
uQxvXA/dj9DsPmSsxzG2bL2uYO1cgUK4NmpwXkn3aaW1l/VTPntQOjs+4n6MWiJs
dX7CRY8rncH/PxDtmSUz/HiWLTIoOv26tGg56hEEWod0A2UiWqV11AJY/XvZaTs0
DcyyIS2L5eFjOvLdx8pN8XcNRfgXX4Zor5f1uMUwFHzGecDnuQF+LxN7r5j/CFNu
bvQlWJpu3FeJPccQpyBRK5VCuKUeLVun3Mym33D7B5VFRg==
-----END CERTIFICATE-----
EOH

  horizon_private_half = <<-EOH
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAw9dXolAH4h0XFzlhcjU0+UHIdwMw85u+CPDyhoeUPJTd/Qjz
2OYSe1Q/ctvz2ufod2jI/XbSmUhIK8blBDAvKIoDz+Q3wXc9a042RJB+0GDIQfMb
C++9WeHkSr+DxTm69lMi1LngWPsKP9jN9AtUcDhT9PCellYsr8Jct1M4SB8yEETa
8p+qgUIoddzPVAHaAJw26Qm3B1RRLFsR95t4IdXhnemCrMXLyI/0CESllKpt+509
wGVDTdi/A2uk7o1jfoU5Y7huWo0IK0Fmym4x3QwIyLU2TSXScFoiCZ17WmaVtmo+
pARb2CVCTPm1bjWKmUmu4IRzjxGLm77UWag2kQIDAQABAoIBAEKrwerBAh4JNz4x
y6nc0T72FS/nBzg30hcrJ/WCnIWPTI+DB7jUgoA36y3IEZl5j9tu8dXQKNwEDoXQ
vVCSsstDSQ7yK8USOfeY9cKbyoBYInTJNXD32eeKjnSgBFUVVT/ch6QR7317YT7h
KSQm40Uc+AAQFn0psybWrUe/7g4m78ViJgh1SdFmjxjo1tvCb4zq1TJ6Kcbfd4Ou
1dus5+NFdMDIJKghMuFuceWEWITo5HIKR+GUZKghqU2SIx89NiWXWPN4eFRWywKM
1TEiaUFea3Twp6vpyU5VGAFnmGKwxVfMnaB9owSwsTyFQtMI9xv7MyjEKWPlNt5T
K1J+SJECgYEA8HiHEt1EoyUh7sCDQbOWaoD53PPPfiK1nmpds/cE+grFYBmXeg8/
yxUldu4YKix8R3OP/zkHcUWCtqoQyXLjmwR76awCNfKVR49jk3BPxDZaFq65KGVa
sad6nL3wktczMyXYduLq6mBW2s0raSOzDPXNUKA68SMvEuktZDxlIU0CgYEA0Hz+
+RUlNjZiDvY2xxgF38rJGSvXHfOIlUdoQRfQdBsE5M/AtVgeLzW5amlJCnPPcz+b
ZgZBjo74YCKbTL18lPuhn+mhi9NRkW9Eq+SMNWhHhl3RjAjMo+AmTQg2QaEIIIY+
QUah9PsngIKuHtmYTS8QwBpoQidsQYMZXWpQyFUCgYACTPTl3k4QzYMkmJzo3QH8
ZN1/GqoKh+R67oOU/DEE/2NiBvynA0xV8g7Ys3Bxvtk1icp/45jJoaOdgcUFWF8L
FaDl3Gps/7Qj6iBGwdVRiD+WZfeJhma2umZ2525MyVhJDfyjLoqW0XMjRsE6kUfe
QN/E/LNzqSWDJc30XouNJQKBgGyesrhSq/BypOPmouNXQLg3jk3u6URRfPdJHKfN
IG1dJk+PbXcNUayG8PLfp44qiAojOXMOD1mWYxCy9vYkQqPb9Xi6389ZaUW8Eqr7
h5DLo3f9qQ6sBvHZ9hpsDNhkbTeEuSqJAhgAQbRSYSTxeMe9nZx4JZlRsLTw+GYS
3cOBAoGAI1wTP0/OhYUbpxkqvP4gqvEiveaSwSAcackoIRTAwDPDXEDjwToAkGKZ
F+/izeSPdMvYPcm3JKjsgfArjsvLJ+4jIoSLQNMzr0VLHstxsyJ7pCddesem8o3R
CgE0Yfkw93N6enWr3U+IVff9COwEce+WwEzJdNBVP/r6c+DaJWY=
EOH
  [horizon_private_half, horizon_public_half]
end

# Set up data bags
unless defined? DATA_BAGS_CONF
  DATA_BAGS_CONF = {}.tap do |conf|
    # data_bags/certs
    conf['certs'] = {}.tap do |certs|
      horizon_private, horizon_public = generate_horizon_https_keypair
      certs['horizon.key'] = horizon_private
      certs['horizon.pem'] = horizon_public
    end

    # data_bags/db_passwords
    conf['db_passwords'] = {}.tap do |db_passwords|
      %w(celiometer cinder dash glance gnocchi heat horizon ironic keystone murano neutron nova_api nova_cell0 nova swift trove designate).each do |db_user|
        db_passwords[db_user] = generate_password
      end
      # special mysqlroot password
      db_passwords['mysqlroot'] = 'root'
    end

    # data_bags/keystone
    conf['keystone'] = {}.tap do |keystone|
      # don't know how these are generated
      %w(fernet_key0 fernet_key1).each do |key|
        keystone[key] = 'WlyklfUkLFdkZPqBokHhyVJn+p318nZ4MAZiyw/XYns='
      end
    end

    # data_bags/secrets
    conf['secrets'] = {}.tap do |secrets|
      %w(dispersion_auth_key dispersion_auth_user neutron_metadata_secret openstack_identity_bootstrap_token orchestration_auth_encryption_key).each do |secret_item|
        secrets[secret_item] = generate_token(secret_item)
      end
    end

    # data_bags/service_passwords
    conf['service_passwords'] = {}.tap do |service_passwords|
      %w(block-storage compute image network orchestration placement telemetry-metric telemetry dns).each do |service|
        service_passwords["openstack-#{service}"] = generate_password
      end
    end

    # data_bags/user_passwords
    conf['user_passwords'] = {}.tap do |user_passwords|
      %w(guest openstack).each do |user|
        user_passwords[user] = generate_password
      end
      user_passwords['admin'] = 'admin'
    end
  end
end

puts "TRACE: Loaded conf/data_bags.rb" if verbose
