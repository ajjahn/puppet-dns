# == Class dns::server::service
#
class dns::server::service (
  $service = $dns::server::params::service
) inherits dns::server::params {

  service { $service:
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
    require    => Class['dns::server::config']
  }

}
