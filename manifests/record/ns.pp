# == Define: dns::record::ns
#
# Wrapper of dns::record to set NS records
#
define dns::record::ns (
  $zone,
  $data,
  $ttl = '',
  $host = $name ) {

  $alias = "${host},NS,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'NS',
    data   => $data
  }
}
