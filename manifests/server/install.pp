# == Class dns::server
#
class dns::server::install (
  $necessary_packages = $dns::server::necessary_packages,
  $ensure_packages    = $dns::server::ensure_packages,
) inherits dns::server::params {

  package { $necessary_packages :
    ensure => $ensure_packages,
  }

}
