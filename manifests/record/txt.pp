# == Define dns::record::txt
#
# Wrapper for dns::record for TXT records
#
define dns::record::txt (
  $zone,
  $data,
  $ttl = '',
  $host = $name) {

  $alias = "${name},TXT,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'TXT',
    data   => $data
  }
}
