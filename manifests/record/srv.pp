define dns::record::srv (
  $zone,
  $service,
  $proto = "tcp",
  $pri,
  $weight,
  $port,
  $target,
  $ttl = '') {

  $alias = "${service}:${proto}@${target}:${port},${pri},${weight},SRV,${zone}"

  $host = "_${service}._${proto}.${zone}."

  dns::record { $alias:
    zone        => $zone,
    host        => $host,
    ttl         => $ttl,
    record      => 'SRV',
    data        => "${pri}\t${weight}\t${port}\t${target}"
  }
}
