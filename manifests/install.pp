class dns::install {
  
  package { "bind9":
    ensure => installed,
  }
  
}