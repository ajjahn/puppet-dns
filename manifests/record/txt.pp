define dns::record::txt ($host, $zone, $data, $ttl = '') {

  dns::record { "${host},TXT,${zone}":
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'TXT',
    data   => $data
  }
}
