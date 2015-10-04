# == Define dns::record::a
#
# Wrapper for dns::record to set an A record, optionally
# also setting a PTR at the same time.
#
define dns::record::a (
  $zone,
  $data,
  $ttl = '',
  $ptr = false,
  $host = $name ) {

  $alias = "${name},A,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $host,
    ttl  => $ttl,
    data => $data
  }

  if $ptr == 'all' {
    dns::record::ptr::by_ip { $data: host => $host, zone => $zone }
  } elsif $ptr == 'first' or str2bool($ptr) {
    $ip = inline_template('<%= @data.kind_of?(Array) ? @data.first : @data %>')
    dns::record::ptr::by_ip { $ip: host => $host, zone => $zone }
  }
}
