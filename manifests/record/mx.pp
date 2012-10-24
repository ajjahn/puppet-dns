define dns::record::mx ($host, $zone, $data, $ttl = '', $preference = '0') {

  dns::record { "${host},MX,${zone}":
    zone       => $zone,
    host       => $host,
    ttl        => $ttl,
    record     => 'MX',
    preference => $preference,
    data       => "${data}.",
    order      => 2
  }
}
