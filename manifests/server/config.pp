class dns::server::config inherits dns::server::params {

  file { $cfg_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }
  file { "${cfg_dir}/zones":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
    require => File["${cfg_dir}"],
  }
  file { "${cfg_dir}/bind.keys.d/":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
    require => File["${cfg_dir}"],
  }

  file { "${cfg_dir}/puppet-scripts":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
    require => File["${cfg_dir}"],
  }
  file { "${cfg_dir}/puppet-scripts/zone_soa.sh":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0755',
    content => template("${module_name}/zone_soa.sh.erb"),
    require => File["${cfg_dir}/puppet-scripts"],
  }

  file { "${cfg_dir}/named.conf":
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => [File["${cfg_dir}"], Class['dns::server::install']],
    notify  => Class['dns::server::service'],
  }

  concat { "${cfg_dir}/named.conf.local":
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service'],
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${cfg_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n",
  }

}
