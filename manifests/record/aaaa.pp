# == Define: dns::record::aaaa
#
# Wrapper of dns::record to set AAAA records
#
define dns::record::aaaa (
  Variant[String, Tuple] $data,
  Variant[Stdlib::Host, Tuple] $zone,
  Variant[Stdlib::Host, String] $host = $name,
  String $ttl = '',
  Stdlib::Absolutepath $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},AAAA,${zone}"

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'AAAA',
    data     => $data,
    data_dir => $data_dir,
  }
}
