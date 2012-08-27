define dns::record::mx ($zone, $data, $ttl = '', $preference = '0') {

  $alias = "${name},MX,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $name,
    ttl => $ttl,
    record => 'MX',
    preference => '0',
    data => "${data}.",
    order => 2
  }
}
