define dns::record::txt (
  $zone,
  $data,
  $ttl = '',
  $host = $name) {

  $alias = "${host},TXT,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'TXT',
    data   => $data
  }
}
