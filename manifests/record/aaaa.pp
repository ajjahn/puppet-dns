define dns::record::aaaa (
  $zone,
  $data,
  $ttl = '',
  $host = $name ) {

  $alias = "${host},AAAA,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'AAAA',
    data   => $data
  }
}
