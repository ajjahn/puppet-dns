class dns::config {

  file { "/etc/bind":
    ensure => directory,
    owner => "bind",
    group => "bind",
    mode => 0755,
  }
  
  file { "/etc/bind/named.conf":
    ensure => present,
    owner => "bind",
    group => "bind",
    mode => 0644,
    require => [File["/etc/bind"], Class["dns::install"]],
    notify => Class["dns::service"],
  }

}