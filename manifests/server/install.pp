class dns::server::install {

  $necessary_packages = [ 'bind9', 'dnssec-tools']

  package { $necessary_packages :
    ensure => latest,
  }

}
