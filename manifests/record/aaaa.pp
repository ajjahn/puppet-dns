define dns::record::aaaa ($host, $zone, $data, $ttl = '') {

  $alias = "${name},AAAA,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $name,
    ttl    => $ttl,
    record => 'AAAA',
    data   => $data
  }
}
