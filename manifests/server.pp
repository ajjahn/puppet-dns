# == Class dns::server
#
class dns::server (
  $cfg_dir  = $dns::server::params::cfg_dir,
  $cfg_file = $dns::server::params::cfg_file,
  $data_dir = $dns::server::params::data_dir,
  $owner    = $dns::server::params::owner,
  $group    = $dns::server::params::group,

  $necessary_packages = $dns::server::params::necessary_packages,
  $ensure_packages    = $dns::server::params::ensure_packages,

  $default_file          = $dns::server::params::default_file,
  $default_template      = $dns::server::params::default_template,

  $service = $dns::server::params::service
) inherits dns::server::params {
  class { 'dns::server::install': } ->
  class { 'dns::server::config': } ~>
  class { 'dns::server::service': }
}
