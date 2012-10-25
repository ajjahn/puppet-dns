define dns::record::mx ($host, $zone, $data, $ttl = '', $preference = '0') {

  $alias = "${name},MX,${zone}"

  dns::record { $alias:
    zone       => $zone,
    host       => $name,
    ttl        => $ttl,
    record     => 'MX',
    preference => $preference,
    data       => "${data}.",
    order      => 2
  }
}
