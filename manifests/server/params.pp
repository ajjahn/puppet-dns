# == Class dns::server::params
#
class dns::server::params {
  case $::osfamily {
    'Debian': {
      $cfg_dir            = '/etc/bind'
      $cfg_file           = '/etc/bind/named.conf'
      $data_dir           = '/etc/bind/zones'
      $root_hint          = "${cfg_dir}/db.root"
      $rfc1912_zones_cfg  = "${cfg_dir}/named.conf.default-zones"
      $rndc_key_file      = "${cfg_dir}/ns-example-com_rndc-key"
      $group              = 'bind'
      $owner              = 'bind'
      $package            = 'bind9'
      $service            = 'bind9'
      $necessary_packages = [ 'bind9', 'dnssec-tools' ]
      $default_dnssec_validation = 'auto'
    }
    'RedHat': {
      $cfg_dir            = '/etc/named'
      $cfg_file           = '/etc/named.conf'
      $data_dir           = '/var/named'
      $root_hint          = "${data_dir}/named.ca"
      $rfc1912_zones_cfg  = '/etc/named.rfc1912.zones'
      $rndc_key_file      = '/etc/named.root.key'
      $group              = 'named'
      $owner              = 'named'
      $package            = 'bind'
      $service            = 'named'
      $necessary_packages = [ 'bind', ]
      if $::operatingsystemmajrelease =~ /^[1-5]$/ {
        $default_dnssec_validation = 'absent'
      } else {
        $default_dnssec_validation = 'auto'
      }
    }
    default: {
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
  $ensure_packages = latest
}
