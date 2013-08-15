define dns::key {

  notify { Exec["dnssec-keygen-${name}"]:} 

  file {"/tmp/${name}-secret.sh":
    ensure => file,
    require => File["/etc/bind/bind.keys.d"],
    content => template('bind/secret')
  }

  exec {"dnssec-keygen-${name}":
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => '/etc/bind/bind.keys.d',
    require     => [Package['dnssec-tools','bind9'],File['/etc/bind/bind.keys.d']],
    refreshonly => true,
    notify => Exec["get-secret-from-${name}"]
  }

  exec {"get-secret-from-${name}":
    command => "SECRET=`cat /etc/bind/bind.keys.d/K${name}.+*+*.key |tr -s \" \"|cut -d \" \" -f7` cat << EOF > echo \'secret \"\' $SECRET \'\"\' > ${name}.secret",
    cwd         => '/etc/bind/bind.keys.d',
    creates     => "/etc/bind/bind.keys.d/${name}.secret",
    require     => [Package['dnssec-tools','bind9'],File['/etc/bind/bind.keys.d']],
    refreshonly => true,
  }

  concat { "/etc/bind/bind.key.d/$name.key":
    owner   => 'bind',
    group   => 'bind',
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment { "$name.key-header":
    ensure  => present,
    target  => "/etc/bind/bind.key.d/$name.key",
    order   => 1,
    content => template('dns/key.erb'),
    require => Exec["dnssec-keygen-${name}"],
  }
  concat::fragment { "$name.key-secret":
    ensure  => present,
    target  => "/etc/bind/bind.key.d/$name.key",
    order   => 2,
    source  => "/etc/bind/bind.keys.d/${name}.secret",
    require => [Exec["dnssec-keygen-${name}"],File ["/etc/bind/bind.keys.d/${name}.secret"]],
  }
  concat::fragment { "$name.key-footer":
    ensure  => present,
    target  => "/etc/bind/bind.key.d/$name.key",
    order   => 3,
    content => '}:', 
    require => Exec["dnssec-keygen-${name}"],
  }
}
