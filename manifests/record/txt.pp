define dns::record::txt ($zone, $data, $ttl = '') {

  $alias = "${name},TXT,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $name,
    ttl => $ttl,
    record => 'TXT',
    data => $data
  }
}
