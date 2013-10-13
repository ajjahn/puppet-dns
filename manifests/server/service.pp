class dns::server::service inherits dns::server::params {

  service { $service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['dns::server::config']
  }

}
