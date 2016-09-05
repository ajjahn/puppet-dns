#== Class dns::collector
#
# ?
class dns::collector {
  Dns::Member <<| |>> {
    require => Class['dns::server'],
    notify  => Class['dns::server::service']
  }
}
