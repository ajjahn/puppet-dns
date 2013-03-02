class dns::server::config inherits dns::server::params {

  line { 'include_named.conf.local':
    file    => "${confdir}/named.conf",
    line    => "include \"${dir}/named.conf.local\";",
    require => Package[$package],
    notify  => Class['dns::server::service']
  }

  concat { "${dir}/named.conf.local":
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}
