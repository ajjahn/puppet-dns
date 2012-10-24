class dns::collector {
  Member <<| |>> {
    require => Class['dns::server'],
    notify  => Class['dns::server::service']
  }
}