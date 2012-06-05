class dns::service {

  service { "bind9":
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    require => Class["dns::config"]
  }

}