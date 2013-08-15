define dns::key {

  file {"/tmp/${name}-secret.sh": 
    ensure => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify => Exec["dnssec-keygen-${name}"],
  }
    

  exec {"dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => '/etc/bind/bind.keys.d',
    require     => [Package['dnssec-tools','bind9'],File['/etc/bind/bind.keys.d']],
    refreshonly => true,
    notify => Exec["get-secret-from-${name}"],
  }

  exec {"get-secret-from-${name}":
    command => "/tmp/${name}-secret.sh",
    cwd         => '/etc/bind/bind.keys.d',
    creates     => "/etc/bind/bind.keys.d/${name}.secret",
    require     => [Exec["dnssec-keygen-${name}"],File['/etc/bind/bind.keys.d',"/tmp/${name}-secret.sh"]],
    refreshonly => true,
  }
 
  file { "/etc/bind/bind.keys.d/${name}.secret":
    require => Exec["get-secret-from-${name}"],
  }

  concat { "/etc/bind/bind.keys.d/${name}.key":
    owner   => 'bind',
    group   => 'bind',
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment { "${name}.key-header":
    ensure  => present,
    target  => "/etc/bind/bind.keys.d/${name}.key",
    order   => 1,
    content => template('dns/key.erb'),
    require => [Exec["get-secret-from-${name}"], File["/etc/bind/bind.keys.d/${name}.secret"]],
  }
  concat::fragment { "${name}.key-secret":
    ensure  => present,
    target  => "/etc/bind/bind.keys.d/${name}.key",
    order   => 2,
#    content => template("/etc/bind/bind.keys.d/${name}.secret"),
    source  => "/etc/bind/bind.keys.d/${name}.secret",
    require => [ Exec[ "get-secret-from-${name}" ], File["/etc/bind/bind.keys.d/${name}.secret"]],
  }
  concat::fragment { "${name}.key-footer":
    ensure  => present,
    target  => "/etc/bind/bind.keys.d/${name}.key",
    order   => 3,
    content => '}:', 
    require => [Exec["get-secret-from-${name}"], File["/etc/bind/bind.keys.d/${name}.secret"]],
  }
  #concat::fragment{"named.conf.local.${name}.key":
  #  ensure  => present,
  #  target  => '/etc/bind/named.conf.local',
  #  content => templates
  #}

}
