# == Class dns::server
#
class dns::server (
  String $service = $dns::server::params::service,

  $necessary_packages = $dns::server::params::necessary_packages,
  $ensure_packages    = $dns::server::params::ensure_packages,

  String $cfg_dir  = $dns::server::params::cfg_dir,
  String $cfg_file = $dns::server::params::cfg_file,
  Stdlib::Absolutepath $data_dir = $dns::server::params::data_dir,
  String $owner    = $dns::server::params::owner,
  String $group    = $dns::server::params::group,

  Boolean $enable_default_zones = true,
) inherits dns::server::params {
  class { 'dns::server::install':
    necessary_packages => $necessary_packages,
    ensure_packages    => $ensure_packages,
  } -> class { 'dns::server::config':
    cfg_dir              => $cfg_dir,
    cfg_file             => $cfg_file,
    data_dir             => $data_dir,
    owner                => $owner,
    group                => $group,
    enable_default_zones => $enable_default_zones,
  } ~> class { 'dns::server::service':
    service => $service,
  }
}
