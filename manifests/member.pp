class dns::member {
  @@member { $::fqdn:
    domain    => $::domain,
    hostname  => $::hostname,
    ipaddress => $::ipaddress
  }
}

define dns::member ($domain, $hostname, $ipaddress) {
  dns::record::a { $hostname:
    zone => $domain,
    data => $ipaddress,
    ptr  => true;
  }
}
