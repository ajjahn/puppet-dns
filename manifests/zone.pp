# == Define dns::zone
#
define dns::zone (
  $soa = "${::fqdn}.",
  $soa_email = "root.${::fqdn}.",
  $zone_ttl = '604800',
  $zone_refresh = '604800',
  $zone_retry = '86400',
  $zone_expire = '2419200',
  $zone_minimum = '604800',
  $nameservers = [ $::fqdn ],
  $reverse = false,
  $zone_type = 'master',
  $allow_transfer = [],
  $allow_forwarder = [],
  $allow_update = undef,
  $forward_policy = 'first',
  $slave_masters = undef,
  $zone_notify = false,
  $ensure = present
) {

  $cfg_dir = $dns::server::params::cfg_dir

  validate_array($allow_transfer)
  validate_array($allow_forwarder)
  if $dns::server::options::forwarder and $allow_forwarder {
    fatal("You cannot specify a global forwarder and \
    a zone forwarder for zone ${soa}")
  }
  if !member(['first', 'only'], $forward_policy) {
    error('The forward policy can only be set to either first or only')
  }

  $zone = $reverse ? {
    true    => "${name}.in-addr.arpa",
    default => $name
  }

  $zone_file = "${dns::server::params::data_dir}/db.${name}"
  $zone_file_stage = "${zone_file}.stage"

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } elsif $zone_type == 'master' {
    # Zone Database

    # If it is a dynamic zone, we don't want to overwrite the existing zone file as it might
    # destroy records that have been added
    if $allow_update {
      $replace_zone_file = false
      $zone_bump_serial = undef
    } else {
      $replace_zone_file = true
      $zone_bump_serial = Exec["bump-${zone}-serial"]
    }

    # Create "fake" zone file without zone-serial
    concat { $zone_file_stage:
      owner   => $dns::server::params::owner,
      group   => $dns::server::params::group,
      mode    => '0644',
      require => [Class['concat::setup'], Class['dns::server']],
      replace => $replace_zone_file,
      notify  => $zone_bump_serial
    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file_stage,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }

    # Generate real zone from stage file through replacement _SERIAL_ template
    # to current timestamp. A real zone file will be updated only at change of
    # the stage file, thanks to this serial is updated only in case of need.
    $zone_serial = inline_template('<%= Time.now.to_i %>')
    exec { "bump-${zone}-serial":
      command     => "sed '8s/_SERIAL_/${zone_serial}/' ${zone_file_stage} > ${zone_file}",
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      provider    => posix,
      user        => $dns::server::params::owner,
      group       => $dns::server::params::group,
      require     => Class['dns::server::install'],
      notify      => Class['dns::server::service'],
    }
  } else {
    # For any zone file that is not a master zone, we should make sure
    # we don't have a staging file
    concat { $zone_file_stage:
      ensure => absent
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    ensure  => $ensure,
    target  => "${cfg_dir}/named.conf.local",
    order   => 3,
    content => template("${module_name}/zone.erb")
  }

}
