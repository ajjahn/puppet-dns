# == Define dns::record::dname
#
# Wrapper for dns::record to set a CNAME
#
define dns::record::cname (
  $zone,
  $data,
  $ttl = '',
  $host = $name) {

  $alias = "${host},CNAME,${zone}"

  $qualified_data = $data ? {
    '@'     => $data,
    /\.$/   => $data,
    default => "${data}."
  }

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'CNAME',
    data   => $qualified_data
  }
}
