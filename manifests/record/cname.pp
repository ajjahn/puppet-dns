define dns::record::cname ($host, $zone, $data, $ttl = '') {

  dns::record { "${host},CNAME,${zone}":
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'CNAME',
    data   => "${data}."
  }
}
