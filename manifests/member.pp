# == Class dns::member
#
define dns::member ($domain, $hostname, $ipaddress) {
  dns::record::a { $hostname:
    zone => $domain,
    data => $ipaddress,
    ptr  => true;
  }
}
