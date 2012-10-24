class dns::server::config {

  file { '/etc/bind':
    ensure => directory,
    owner  => 'bind',
    group  => 'bind',
    mode   => '0755',
  }

  concat { '/etc/bind/named.conf.local':
    owner   => 'bind',
    group   => 'bind',
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment { 'named.conf.local.header':
    ensure  => present,
    target  => '/etc/bind/named.conf.local',
    order   => 1,
    content => "// File managed by Puppet.\n";
  }

}
