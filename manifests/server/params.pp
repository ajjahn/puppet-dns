# == Class dns::server::params
#
class dns::server::params {
  case $::osfamily {
    'Debian': {
      $cfg_dir            = '/etc/bind'
      $cfg_file           = '/etc/bind/named.conf'
      $data_dir           = '/var/lib/bind/zones'
      $working_dir        = '/var/cache/bind'
      $root_hint          = "${cfg_dir}/db.root"
      $rfc1912_zones_cfg  = "${cfg_dir}/named.conf.default-zones"
      $rndc_key_file      = "${cfg_dir}/rndc.key"
      $group              = 'bind'
      $owner              = 'bind'
      $package            = 'bind9'
      $service            = 'bind9'
      $default_file       = '/etc/default/bind9'
      $default_template   = 'default.debian.erb'
      $default_dnssec_enable     = true
      $default_dnssec_validation = 'auto'
      if versioncmp( $::operatingsystemmajrelease, '8' ) >= 0 {
        $necessary_packages = ['bind9']
      } else {
        $necessary_packages = [ 'bind9', 'dnssec-tools' ]
      }
    }
    'RedHat': {
      $cfg_dir            = '/etc/named'
      $cfg_file           = '/etc/named.conf'
      $data_dir           = '/var/named'
      $working_dir        = "${data_dir}/data"
      $root_hint          = "${data_dir}/named.ca"
      $rfc1912_zones_cfg  = '/etc/named.rfc1912.zones'
      $rndc_key_file      = '/etc/named.root.key'
      $group              = 'named'
      $owner              = 'named'
      $package            = 'bind'
      $service            = 'named'
      $necessary_packages = [ 'bind', ]
      $default_file       = '/etc/sysconfig/named'
      $default_template   = 'default.redhat.erb'
      if $::operatingsystemmajrelease =~ /^[1-5]$/ {
        $default_dnssec_enable     = false
        $default_dnssec_validation = 'absent'
      } else {
        $default_dnssec_enable     = true
        $default_dnssec_validation = 'auto'
      }
    }
    default: {
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
  $ensure_packages = latest
}
