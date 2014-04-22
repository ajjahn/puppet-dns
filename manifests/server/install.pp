class dns::server::install (
  $necessary_packages = $dns::server::params::necessary_packages
) inherits dns::server::params {

  package { $necessary_packages :
    ensure => latest,
  }

}
