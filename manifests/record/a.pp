define dns::record::a (
  $zone,
  $data,
  $ttl = '',
  $ptr = false,
  $host = $name ) {

  $alias = "${host},A,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $host,
    ttl  => $ttl,
    data => $data
  }

  if $ptr {
    $ip = inline_template('<%= data.kind_of?(Array) ? data.first : data %>')
    $reverse_zone = inline_template('<%= ip.split(".")[0..-2].reverse.join(".") %>.IN-ADDR.ARPA')
    $rrfqdn = inline_template('<%= ip.split(".").reverse.join(".") %>.IN-ADDR.ARPA')

    dns::record::ptr { $rrfqdn:
      zone => $reverse_zone,
      data => "${host}.${zone}"
    }
  }
}
