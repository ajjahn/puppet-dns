# == Class dns::server
#
class dns::server::config (
  $cfg_dir  = $dns::server::cfg_dir,
  $cfg_file = $dns::server::cfg_file,
  $data_dir = $dns::server::data_dir,
  $owner    = $dns::server::owner,
  $group    = $dns::server::group,
) inherits dns::server::params {

  file { $cfg_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { $data_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { "${cfg_dir}/bind.keys.d/":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }

  file { $cfg_file:
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template("${module_name}/named.conf.erb"),
    require => [
      File[$cfg_dir],
      Class['dns::server::install']
    ],
    notify  => Class['dns::server::service'],
  }

  concat { "${cfg_dir}/named.conf.local":
    owner  => $owner,
    group  => $group,
    mode   => '0644',
    notify => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    target  => "${cfg_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

  include dns::server::default

}
