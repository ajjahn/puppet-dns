define dns::record::a ($zone, $data, $ttl = '', $ptr = false) {

  $alias = "${name},A,${zone}"

  dns::record { $alias:
    zone => $zone,
    host => $name,
    ttl => $ttl,
    data => $data
  }

  if $ptr {
    $ip = inline_template('<%= data.kind_of?(Array) ? data.first : data %>')
    $reverse_zone = inline_template('<%= ip.split(".")[0..-2].reverse.join(".") %>')
    $octet = inline_template('<%= ip.split(".")[-1] %>')

    dns::record::ptr { $octet:
      zone => $reverse_zone,
      data => "${name}.${zone}"
    }
  }
}
