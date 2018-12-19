# == Define dns::record::dname
#
# Wrapper for dns::record to set a CNAME
#
define dns::record::cname (
  $zone,
  $data,
  $ttl = '',
  $host = $name,
  $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},CNAME,${zone}"

  $qualified_data = $data ? {
    '@'     => $data,
    /\.$/   => $data,
    default => "${data}."
  }

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'CNAME',
    data     => $qualified_data,
    data_dir => $data_dir,
  }
}
