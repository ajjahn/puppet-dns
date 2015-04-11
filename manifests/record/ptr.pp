# == Define dns::record::prt
#
# Wrapper for dns::record to set PTRs
#
define dns::record::ptr (
  $zone,
  $data,
  $ttl = '',
  $host = $name
) {

  $alias = "${name},PTR,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}."
  }
}
