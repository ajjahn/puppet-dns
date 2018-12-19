# == Define: dns::record::aaaa
#
# Wrapper of dns::record to set AAAA records
#
define dns::record::aaaa (
  String $zone,
  String $data,
  String $ttl = '',
  String $host = $name,
  Tuple $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},AAAA,${zone}"

  Stdlib::Fqdn($zone)
  Stdlib::Host($data)
  Stdlib::Fqdn($host)

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'AAAA',
    data     => $data,
    data_dir => $data_dir,
  }
}
