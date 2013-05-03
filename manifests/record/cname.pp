define dns::record::cname (
  $zone,
  $data,
  $ttl = '',
  $host = $name) {

  $alias = "${host},CNAME,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'CNAME',
    data   => $data
  }
}
