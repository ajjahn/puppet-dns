# == Class dns::server::params
#
class dns::server::params {
  case $::osfamily {
    'Debian': {
      String $cfg_dir            = '/etc/bind'
      String $cfg_file           = '/etc/bind/named.conf'
      String $data_dir           = '/var/lib/bind/zones'
      String $working_dir        = '/var/cache/bind'
      String $root_hint          = "${cfg_dir}/db.root"
      String $rfc1912_zones_cfg  = "${cfg_dir}/named.conf.default-zones"
      String $rndc_key_file      = "${cfg_dir}/rndc.key"
      String $group              = 'bind'
      String $owner              = 'bind'
      String $package            = 'bind9'
      String $service            = 'bind9'
      String $default_file       = '/etc/default/bind9'
      String $default_template   = 'default.debian.erb'
      Boolean $default_dnssec_enable     = true
      String $default_dnssec_validation = 'auto'
      if versioncmp( $::operatingsystemmajrelease, '8' ) >= 0 {
        $necessary_packages = ['bind9']
      } else {
        $necessary_packages = [ 'bind9', 'dnssec-tools' ]
      }
    }
    'RedHat': {
      String $cfg_dir            = '/etc/named'
      String $cfg_file           = '/etc/named.conf'
      String $data_dir           = '/var/named'
      String $working_dir        = "${data_dir}/data"
      String $root_hint          = "${data_dir}/named.ca"
      String $rfc1912_zones_cfg  = '/etc/named.rfc1912.zones'
      String $rndc_key_file      = '/etc/named.root.key'
      String $group              = 'named'
      String $owner              = 'named'
      String $package            = 'bind'
      String $service            = 'named'
      $necessary_packages = [ 'bind', ]
      String $default_file       = '/etc/sysconfig/named'
      String $default_template   = 'default.redhat.erb'
      if $::operatingsystemmajrelease =~ /^[1-5]$/ {
        Boolean $default_dnssec_enable     = false
        String $default_dnssec_validation = 'absent'
      } else {
        Boolean $default_dnssec_enable     = true
        String $default_dnssec_validation = 'auto'
      }
    }
    default: {
      fail("dns::server is incompatible with this osfamily: ${::osfamily}")
    }
  }
  $ensure_packages = latest
}
