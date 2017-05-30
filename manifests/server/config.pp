# == Class dns::server
#
class dns::server::config (
  $cfg_dir              = $dns::server::params::cfg_dir,
  $cfg_file             = $dns::server::params::cfg_file,
  $data_dir             = $dns::server::params::data_dir,
  $owner                = $dns::server::params::owner,
  $group                = $dns::server::params::group,
  $enable_default_zones = true,
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

  # Configure default zones with a concat so we could add more zones in it
  concat {$dns::server::params::rfc1912_zones_cfg:
    owner          => $owner,
    group          => $group,
    mode           => '0644',
    ensure_newline => true,
    notify         => Class['dns::server::service'],
  }

  concat::fragment {'default-zones.header':
    target => $dns::server::params::rfc1912_zones_cfg,
    order  => '00',
    source => "puppet:///modules/${module_name}/named.conf.default-zones",
  }

  include dns::server::default

}
