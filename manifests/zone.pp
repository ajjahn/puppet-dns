define dns::zone (
  $soa = "${::fqdn}.",
  $soa_email = "root.${::fqdn}.",
  $serial = false,
  $zone_ttl = '604800',
  $zone_refresh = '604800',
  $zone_retry = '86400',
  $zone_expire = '2419200',
  $zone_minimum = '604800',
  $nameservers = [ $::fqdn ],
  $reverse = false,
  $zone_type = 'master',
  $allow_transfer = [],
  $slave_masters = undef,
  $zone_notify = false,
  $ensure = present
) {

  validate_array($allow_transfer)

  $zone_serial = $serial ? {
    false   => inline_template('<%= Time.now.to_i %>'),
    default => $serial
  }

  $zone = $reverse ? {
    true    => "${name}.in-addr.arpa",
    default => $name
  }

  $zone_file = "/etc/bind/zones/db.${name}"

  if $ensure == absent {
    file { $zone_file:
      ensure => absent,
    }
  } else {
    # Zone Database
    concat { $zone_file:
      owner   => 'bind',
      group   => 'bind',
      mode    => '0644',
      require => [Class['concat::setup'], Class['dns::server']],
      notify  => Class['dns::server::service']
    }
    concat::fragment{"db.${name}.soa":
      target  => $zone_file,
      order   => 1,
      content => template("${module_name}/zone_file.erb")
    }
  }

  # Include Zone in named.conf.local
  concat::fragment{"named.conf.local.${name}.include":
    ensure  => $ensure,
    target  => '/etc/bind/named.conf.local',
    order   => 3,
    content => template("${module_name}/zone.erb")
  }

}
