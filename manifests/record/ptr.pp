define dns::record::ptr ($host, $zone, $data, $ttl = '') {

  dns::record { "${name},PTR,${zone}":
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}."
  }
}
