define dns::record::ptr ($host, $zone, $data, $ttl = '') {

  $alias = "${name},PTR,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $name,
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}."
  }
}
