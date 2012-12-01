define dns::record::ptr (
  $zone,
  $data,
  $ttl = '',
  $host = $name ) {

  $alias = "${host},PTR,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}."
  }
}
