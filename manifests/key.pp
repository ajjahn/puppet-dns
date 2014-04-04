define dns::key {
  include dns::server::params
  $cfg_dir = $dns::server::params::cfg_dir # Used in a template

  file {"/tmp/${name}-secret.sh": 
    ensure => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify => Exec["dnssec-keygen-${name}"],
  }
    

  exec {"dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => "${cfg_dir}/bind.keys.d",
    require     => [
      Package['dnssec-tools','bind9'],
      File["${cfg_dir}/bind.keys.d"],
    ],
    refreshonly => true,
    notify      => Exec["get-secret-from-${name}"],
  }

  exec {"get-secret-from-${name}":
    command     => "/tmp/${name}-secret.sh",
    cwd         => "${cfg_dir}/bind.keys.d",
    creates     => "${cfg_dir}/bind.keys.d/${name}.secret",
    require     => [
      Exec["dnssec-keygen-${name}"],
      File["${cfg_dir}/bind.keys.dr"],
      File["/tmp/${name}-secret.sh"],
    ],
    refreshonly => true,
  }
 
  file { "${cfg_dir}/bind.keys.d/${name}.secret":
    require => Exec["get-secret-from-${name}"],
  }

  concat { "${cfg_dir}/bind.keys.d/${name}.key":
    owner   => $dns::server::params::owner,
    group   => $dns::server::params::group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment { "${name}.key-header":
    ensure  => present,
    target  => "${cfg_dir}/bind.keys.d/${name}.key",
    order   => 1,
    content => template('dns/key.erb'),
    require => [
      Exec["get-secret-from-${name}"],
      File["${cfg_dir}/bind.keys.d/${name}.secret"],
    ],
  }
  concat::fragment { "${name}.key-secret":
    ensure  => present,
    target  => "${cfg_dir}/bind.keys.d/${name}.key",
    order   => 2,
#    content => template("/etc/bind/bind.keys.d/${name}.secret"),
    source  => "${cfg_dir}/bind.keys.d/${name}.secret",
    require => [
      Exec["get-secret-from-${name}"],
      File["${cfg_dir}/bind.keys.d/${name}.secret"]
    ],
  }
  concat::fragment { "${name}.key-footer":
    ensure  => present,
    target  => "${cfg_dir}/bind.keys.d/${name}.key",
    order   => 3,
    content => '}:', 
    require => [
      Exec["get-secret-from-${name}"],
      File["${cfg_dir}/bind.keys.d/${name}.secret"],
    ],
  }
  #concat::fragment{"named.conf.local.${name}.key":
  #  ensure  => present,
  #  target  => "${cfg_dir}/named.conf.local",
  #  content => templates
  #}

}
