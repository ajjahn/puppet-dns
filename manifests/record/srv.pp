# == Define dns::server:srv
#
# Wrapper for dns::zone to set SRV records
#
define dns::record::srv (
  String $zone,
  String $service,
  String $pri,
  String $weight,
  String $port,
  String $target,
  String $proto    = 'tcp',
  String $ttl      = '',
  String $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${service}:${proto}@${target}:${port},${pri},${weight},SRV,${zone}"

  $host = "_${service}._${proto}.${zone}."

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'SRV',
    data     => "${pri}\t${weight}\t${port}\t${target}",
    data_dir => $data_dir,
  }
}
