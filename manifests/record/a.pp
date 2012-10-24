define dns::record::a ($host, $zone, $data, $ttl = '', $ptr = false) {

  dns::record { "${host},A,${zone}":
    zone => $zone,
    host => $host,
    ttl  => $ttl,
    data => $data
  }

  if $ptr {
    $ip = inline_template('<%= data.kind_of?(Array) ? data.first : data %>')
    $reverse_zone = inline_template('<%= ip.split(".")[0..-2].reverse.join(".") %>.IN-ADDR.ARPA')
    $octet = inline_template('<%= ip.split(".")[-1] %>')

    # Using format of "@.example.com" causes reverse dns to fail
    if $host == '@' {
      dns::record::ptr { "${name}.${zone},PTR,${octet}":
        host => $octet,
        zone => $reverse_zone,
        data => "${zone}"
      }
    }
    else {
      dns::record::ptr { "${name}.${zone},PTR,${octet}":
        host => $octet,
        zone => $reverse_zone,
        data => "${host}.${zone}"
      }
    }
  }
}
