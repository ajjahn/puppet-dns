# == Class dns::server
#
class dns::server::config (
  $cfg_dir  = $dns::server::params::cfg_dir,
  $cfg_file = $dns::server::params::cfg_file,
  $data_dir = $dns::server::params::data_dir,
  $owner    = $dns::server::params::owner,
  $group    = $dns::server::params::group,
) inherits dns::server::params {

  $log_dir  = '/var/log/named'
  $log_file = "${log_dir}/named.log"

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
  
  file { '/var/cache/bind':
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0755',
  }
  
  file { $log_dir:
    ensure => directory,
    owner  => $owner,
    group  => $group,
    mode   => '0750',
  }
  
  file { $log_file:
    ensure => file,
    owner  => $owner,
    group  => $group,
    mode   => '0640',
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
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    require => Class['concat::setup'],
    notify  => Class['dns::server::service']
  }

  concat::fragment{'named.conf.local.header':
    ensure  => present,
    target  => "${cfg_dir}/named.conf.local",
    order   => 1,
    content => "// File managed by Puppet.\n"
  }

}