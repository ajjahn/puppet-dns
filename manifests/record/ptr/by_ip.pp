# == Definition: dns::record::ptr::by_ip
#
# This type is defined to allow the dns::record::a resource type to
# use pre-4.x 'iteration' to create reverse ptr records for hosts with
# multiple ip addresses.
#
# === Parameters
#
# * `$ip`
# The ip address for the ptr record.  Defaults to the resource title.
#
# * `$host`
# The (unqualified) host pointed to by this ptr record.
#
# * `$ttl`
# The TTL of the records to be created.  Defaults to undefined.
#
# * `$zone`
# The domain of the host pointed to by this ptr record.
#
# === Actions
#
# Reformats the $ip, $host, $zone parameters to create a `dns::record::ptr` 
# resource
#
# === Examples
#
# @example
#     dns::record::ptr::by_ip { '192.168.128.42':
#       host => 'server' ,
#       zone => 'example.com' ,
#     }
#
# turns into:
#
# @example
#     dns::record::ptr { '42.128.168.192.in-addr.arpa':
#       host => '42' ,
#       zone => '128.168.192.in-addr.arpa' ,
#       data => 'server.example.com' ,
#     }
#
# ---
# @example
#     dns::record::ptr::by_ip { [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ]:
#       host => 'multihomed-server' ,
#       zone => 'example.com' ,
#     }
#
# turns into:
#
# @example
#     dns::record::ptr { '68.128.168.192.in-addr.arpa':
#       host => '68' ,
#       zone => '128.168.192.in-addr.arpa' ,
#       data => 'multihomed-server.example.com' ,
#
# @example
#     dns::record::ptr { '69.128.168.192.in-addr.arpa':
#       host => '69' ,
#       zone => '128.168.192.in-addr.arpa' ,
#       data => 'multihomed-server.example.com' ,
#
# @example
#     dns::record::ptr { '70.128.168.192.in-addr.arpa':
#       host => '70' ,
#       zone => '128.168.192.in-addr.arpa' ,
#       data => 'multihomed-server.example.com' ,
#     }

define dns::record::ptr::by_ip (
  $host,
  $zone,
  $ttl = undef ,
  $ip = $name ) {

  # split the IP address up into three host/zone pairs based on class A, B, or C splits:
  # For IP address A.B.C.D,
  # class C => host D / zone C.B.A.in-addr.arpa
  # class B => host D.C / zone B.A.in-addr.arpa
  # class A => host D.C.B / zone A.in-addr.arpa
  $class_c_zone = inline_template('<%= @ip.split(".").reverse()[1..3].join(".") %>.in-addr.arpa')
  $class_c_host = inline_template('<%= @ip.split(".").reverse()[0..0].join(".") %>')
  $class_b_zone = inline_template('<%= @ip.split(".").reverse()[2..3].join(".") %>.in-addr.arpa')
  $class_b_host = inline_template('<%= @ip.split(".").reverse()[0..1].join(".") %>')
  $class_a_zone = inline_template('<%= @ip.split(".").reverse()[3..3].join(".") %>.in-addr.arpa')
  $class_a_host = inline_template('<%= @ip.split(".").reverse()[0..2].join(".") %>')

  # Zone names reverse is true
  $reverse_true_class_c_zone = regsubst($class_c_zone, '\.in-addr\.arpa', '')
  $reverse_true_class_b_zone = regsubst($class_b_zone, '\.in-addr\.arpa', '')
  $reverse_true_class_a_zone = regsubst($class_a_zone, '\.in-addr\.arpa', '')

  # Zone names reverse is 'reverse'
  $reverse_class_c_zone = regsubst($ip, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1.\2.\3')
  $reverse_class_b_zone = regsubst($ip, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\1.\2')
  $reverse_class_a_zone = regsubst($ip, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\1')

  # choose the most specific defined reverse zone file (class C, then B, then A).
  # Default to class C if none are defined.

  # Class C
  # Conditions parameter reverse is false
  if defined(Dns::Zone[$class_c_zone]) {
    $reverse_zone = $class_c_zone
    $octet = $class_c_host
  # Conditions (C.B.A|B.A|A) and parameter reverse is true
  } elsif defined(Dns::Zone[$reverse_true_class_c_zone]) and getparam(Dns::Zone[$reverse_true_class_c_zone], 'reverse') == true {
    $reverse_zone = $reverse_true_class_c_zone
    $octet = $class_c_host
  # Conditions (A.B.C|A.B|A) and parameter reverse is 'reverse'
  } elsif defined(Dns::Zone[$reverse_class_c_zone]) and getparam(Dns::Zone[$reverse_class_c_zone], 'reverse') == 'reverse' {
    $reverse_zone = $reverse_class_c_zone
    $octet = $class_c_host
  # Class B
  # Conditions parameter reverse is false
  } elsif defined(Dns::Zone[$class_b_zone]) {
    $reverse_zone = $class_b_zone
    $octet = $class_b_host
  # Conditions (C.B.A|B.A|A) and parameter reverse is true
  } elsif defined(Dns::Zone[$reverse_true_class_b_zone]) and getparam(Dns::Zone[$reverse_true_class_b_zone], 'reverse') == true {
    $reverse_zone = $reverse_true_class_b_zone
    $octet = $class_b_host
  # Conditions (A.B.C|A.B|A) and parameter reverse is 'reverse'
  } elsif defined(Dns::Zone[$reverse_class_b_zone]) and getparam(Dns::Zone[$reverse_class_b_zone], 'reverse') == 'reverse' {
    $reverse_zone = $reverse_class_b_zone
    $octet = $class_b_host
  # Class A
  # Conditions parameter reverse is false
  } elsif defined(Dns::Zone[$class_a_zone]) {
    $reverse_zone = $class_a_zone
    $octet = $class_a_host
  # Conditions (C.B.A|B.A|A) and parameter reverse is true
  } elsif defined(Dns::Zone[$reverse_true_class_a_zone]) and getparam(Dns::Zone[$reverse_true_class_a_zone], 'reverse') == true {
    $reverse_zone = $reverse_true_class_a_zone
    $octet = $class_a_host
  # Conditions (A.B.C|A.B|A) and parameter reverse is 'reverse'
  } elsif defined(Dns::Zone[$reverse_class_a_zone]) and getparam(Dns::Zone[$reverse_class_a_zone], 'reverse') == 'reverse' {
    $reverse_zone = $reverse_class_a_zone
    $octet = $class_a_host
  } else {
    notify { "PTR record for IP address '${ip}' not created: No `dns::zone` resource declared for the class A, B, or C subnet of this IP address.": }
  }

  if $reverse_zone and $octet {
    dns::record::ptr { "${octet}.${reverse_zone}":
      host => $octet,
      zone => $reverse_zone,
      ttl  => $ttl ,
      data => "${host}.${zone}"
    }
  }
}
