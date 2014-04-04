class dns::server::params {
  case $osfamily {
    'Debian': {
       $cfg_dir            = '/etc/bind'
       $cfg_file           = '/etc/bind/named.conf'
       $data_dir           = '/etc/bind/zones'
       $group              = 'bind'
       $owner              = 'bind'
       $package            = 'bind9'
       $service            = 'bind9'
       $necessary_packages = [ 'bind9', 'dnssec-tools']
    }
    default: { 
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
}
