# == Define dns::record::prt
#
# Wrapper for dns::record to set PTRs
#
define dns::record::ptr (
  String $zone,
  String $data,
  String $ttl = '',
  String $host = $name,
  Stdlib:Absolutepath $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},PTR,${zone}"

  Stdlib::Fqdn($zone)
  Stdlib::Host($data)
  Stdlib::Fqdn($host)

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'PTR',
    data     => "${data}.",
    data_dir => $data_dir,
  }
}
