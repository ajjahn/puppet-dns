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
#     dns::record::ptr { '42.128.168.192.IN-ADDR.ARPA':
#       host => '42' ,
#       zone => '128.168.192.IN-ADDR.ARPA' ,
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
#     dns::record::ptr { '68.128.168.192.IN-ADDR.ARPA':
#       host => '68' ,
#       zone => '128.168.192.IN-ADDR.ARPA' ,
#       data => 'multihomed-server.example.com' ,
#
# @example
#     dns::record::ptr { '69.128.168.192.IN-ADDR.ARPA':
#       host => '69' ,
#       zone => '128.168.192.IN-ADDR.ARPA' ,
#       data => 'multihomed-server.example.com' ,
#
# @example
#     dns::record::ptr { '70.128.168.192.IN-ADDR.ARPA':
#       host => '70' ,
#       zone => '128.168.192.IN-ADDR.ARPA' ,
#       data => 'multihomed-server.example.com' ,
#     }

define dns::record::ptr::by_ip (
  $host,
  $zone,
  $ttl = undef ,
  $ip = $name ) {

  # split the IP address up into three host/zone pairs based on class A, B, or C splits:
  # For IP address A.B.C.D,
  # class C => host D / zone C.B.A.IN-ADDR.ARPA
  # class B => host D.C / zone B.A.IN-ADDR.ARPA
  # class A => host D.C.B / zone A.IN-ADDR.ARPA
  $class_C_zone = inline_template('<%= @ip.split(".").reverse()[1..3].join(".") %>.IN-ADDR.ARPA')
  $class_C_host = inline_template('<%= @ip.split(".").reverse()[0..0].join(".") %>')
  $class_B_zone = inline_template('<%= @ip.split(".").reverse()[2..3].join(".") %>.IN-ADDR.ARPA')
  $class_B_host = inline_template('<%= @ip.split(".").reverse()[0..1].join(".") %>')
  $class_A_zone = inline_template('<%= @ip.split(".").reverse()[3..3].join(".") %>.IN-ADDR.ARPA')
  $class_A_host = inline_template('<%= @ip.split(".").reverse()[0..2].join(".") %>')

  # choose the most specific defined reverse zone file (class C, then B, then A).
  # Default to class C if none are defined.
  if defined(Dns::Zone[$class_C_zone]) {
    $reverse_zone = $class_C_zone
    $octet = $class_C_host
  } elsif defined(Dns::Zone[$class_B_zone]) {
    $reverse_zone = $class_B_zone
    $octet = $class_B_host
  } elsif defined(Dns::Zone[$class_A_zone]) {
    $reverse_zone = $class_A_zone
    $octet = $class_A_host
  } else {
    $reverse_zone = $class_C_zone
    $octet = $class_C_host
  }

  dns::record::ptr { "${octet}.${reverse_zone}":
    host => $octet,
    zone => $reverse_zone,
    ttl  => $ttl ,
    data => "${host}.${zone}"
  }
}
