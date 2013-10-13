class dns::server::install inherits dns::server::params {

  package { $necessary_packages :
    ensure => latest,
  }

}
