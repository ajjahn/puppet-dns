define dns::record::aaaa ($host, $zone, $data, $ttl = '') {

  dns::record { "${host},AAAA,${zone}":
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'AAAA',
    data   => $data
  }
}
