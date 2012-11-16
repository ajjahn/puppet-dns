class dns::server::config {

  file { '/etc/bind':
    ensure => directory,
    owner  => 'bind',
    group  => 'bind',
    mode   => '0755',
  }

  file { '/etc/bind/named.conf':
    ensure  => present,
    owner   => 'bind',
    group   => 'bind',
    mode    => '0644',
    require => [File['/etc/bind'], Class['dns::server::install']],
    notify  => Class['dns::server::service'],
  }

  concat { '/etc/bind/named.conf.local':
    owner   => 'bind',
    group   => 'bind',
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => '/etc/bind/named.conf.local',
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}
