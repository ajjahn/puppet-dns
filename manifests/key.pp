define dns::key {

  file { "/tmp/${name}-secret.sh":
    ensure  => file,
    mode    => '0777',
    content => template('dns/secret.erb'),
    notify  => Exec["dnssec-keygen-${name}"],
  }

  exec { "dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => '/etc/bind/bind.keys.d',
    require     => [
      Package['dnssec-tools','bind9'],
      File['/etc/bind/bind.keys.d']
    ],
    refreshonly => true,
    notify      => Exec["get-secret-from-${name}"],
  }

  exec { "get-secret-from-${name}":
    command     => "/tmp/${name}-secret.sh",
    cwd         => '/etc/bind/bind.keys.d',
    creates     => "/etc/bind/bind.keys.d/${name}.secret",
    require     => [
      Exec["dnssec-keygen-${name}"],
      File['/etc/bind/bind.keys.d',"/tmp/${name}-secret.sh"]],
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

  Concat::Fragment {
    ensure  => present,
    target  => "/etc/bind/bind.keys.d/${name}.key",
    require => [
      Exec["get-secret-from-${name}"],
      File["/etc/bind/bind.keys.d/${name}.secret"]
    ],
  }

  concat::fragment { "${name}.key-header":
    order   => 1,
    content => template('dns/key.erb'),
  }

  concat::fragment { "${name}.key-secret":
    order   => 2,
    source  => "/etc/bind/bind.keys.d/${name}.secret",
  }

  concat::fragment { "${name}.key-footer":
    order   => 3,
    content => '}:',
  }

}
