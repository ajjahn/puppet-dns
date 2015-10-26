# == Class dns::server
#
class dns::server {
  class { 'dns::server::install': } ->
  class { 'dns::server::config': } ~>
  class { 'dns::server::service': }
}
