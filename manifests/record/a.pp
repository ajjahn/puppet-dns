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
  $all_ptr = false,
  $host = $name ) {

  $alias = "${name},A,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $host,
    ttl  => $ttl,
    data => $data
  }

  if $all_ptr {
    dns_reverse_ptr_record { $data: host => $host, zone => $zone }
  } elsif $ptr {
    $ip = inline_template('<%= @data.kind_of?(Array) ? @data.first : @data %>')
    dns_reverse_ptr_record { $ip: host => $host, zone => $zone }
  }
}
