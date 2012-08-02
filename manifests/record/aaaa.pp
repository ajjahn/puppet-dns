define dns::record::aaaa ($zone, $data, $ttl = '') {

  $alias = "${name},AAAA,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $name,
    ttl => $ttl,
    record => 'AAAA',
    data => $data
  }
}
