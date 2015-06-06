# == Class define::key
#
define dns::key {
  include dns::server::params
  $cfg_dir = $dns::server::params::cfg_dir # Used in a template

  file { "/tmp/${name}-secret.sh":
    ensure  => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify  => Exec["dnssec-keygen-${name}"],
  }

  exec { "dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => "${cfg_dir}/bind.keys.d",
    require     => [
      Package['dnssec-tools'],
      File["${cfg_dir}/bind.keys.d"],
    ],
    refreshonly => true,
    notify      => Exec["get-secret-from-${name}"],
  }

  exec { "get-secret-from-${name}":
    command     => "/tmp/${name}-secret.sh",
    cwd         => "${cfg_dir}/bind.keys.d",
    creates     => "${cfg_dir}/bind.keys.d/${name}.secret",
    require     => [
      Exec["dnssec-keygen-${name}"],
      File["${cfg_dir}/bind.keys.d"],
      File["/tmp/${name}-secret.sh"],
    ],
    refreshonly => true,
  }

  file { "${cfg_dir}/bind.keys.d/${name}.secret":
    require => Exec["get-secret-from-${name}"],
  }

  concat { "${cfg_dir}/bind.keys.d/${name}.key":
    owner  => $dns::server::params::owner,
    group  => $dns::server::params::group,
    mode   => '0644',
    notify => Class['dns::server::service']
  }

  Concat::Fragment {
    ensure  => present,
    target  => "${cfg_dir}/bind.keys.d/${name}.key",
    require => [
      Exec["get-secret-from-${name}"],
      File["${cfg_dir}/bind.keys.d/${name}.secret"],
    ],
  }

  concat::fragment { "${name}.key-header":
    order   => 1,
    content => template('dns/key.erb'),
  }

  concat::fragment { "${name}.key-secret":
    order  => 2,
    source => "${cfg_dir}/bind.keys.d/${name}.secret",
  }

  concat::fragment { "${name}.key-footer":
    order   => 3,
    content => '};',
  }

}
