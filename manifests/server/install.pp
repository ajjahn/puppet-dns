class dns::server::install {

  package { 'bind9':
    ensure => latest,
  }

}
