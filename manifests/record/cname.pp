define dns::record::cname ($host, $zone, $data, $ttl = '') {

  $alias = "${name},CNAME,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $name,
    ttl    => $ttl,
    record => 'CNAME',
    data   => "${data}."
  }
}
