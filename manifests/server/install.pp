# == Class dns::server
#
class dns::server::install (
  String $necessary_packages = $dns::server::params::necessary_packages,
  Array $ensure_packages     = $dns::server::params::ensure_packages,
) inherits dns::server::params {

  package { $necessary_packages :
    ensure => $ensure_packages,
  }

}
