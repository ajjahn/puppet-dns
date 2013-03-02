class dns::server::install inherits dns::server::params {

  package { $package:
    ensure => latest,
  }

}
