define dns::record::ns (
  $zone,
  $data,
  $ttl = '',
  $preference = '0',
  $host = $name ) {

  $alias = "${host},NS,${zone}"

  dns::record { $alias:
    zone       => $zone,
    host       => $host,
    ttl        => $ttl,
    record     => 'NS',
    preference => $preference,
    data       => "${data}.",
    order      => 2
  }
}
