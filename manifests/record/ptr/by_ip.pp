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
# The host pointed to by this ptr record.  If `$zone` is a non-empty
# domain, it will be appended to the value of `$host` in the `PTR`
# record; if `$zone` is undefined or empty, then `$host`
# must include the domain name (but must *not* include any trailing `.`).
# If `$host` is `@` and `$zone` is non-empty, `$zone` will be used by
# itself in the `PTR` record.
#
# * `$ttl`
# The TTL of the records to be created.  Defaults to undefined.
#
# * `$zone`
# The domain of the host pointed to by this ptr record, with *no* trailing
# `.`.  If not defined, `$host` is assumed to be fully-qualified.
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
#       host => 'server',
#       zone => 'example.com',
#     }
#
# turns into:
#
# @example
#     dns::record::ptr { '42.128.168.192.IN-ADDR.ARPA':
#       host => '42',
#       zone => '128.168.192.IN-ADDR.ARPA',
#       data => 'server.example.com',
#     }
#
# ---
# @example
#     dns::record::ptr::by_ip { [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ]:
#       host => 'multihomed-server.example.com',
#     }
#
# turns into:
#
# @example
#     dns::record::ptr { '68.128.168.192.IN-ADDR.ARPA':
#       host => '68',
#       zone => '128.168.192.IN-ADDR.ARPA',
#       data => 'multihomed-server.example.com',
#
# @example
#     dns::record::ptr { '69.128.168.192.IN-ADDR.ARPA':
#       host => '69',
#       zone => '128.168.192.IN-ADDR.ARPA',
#       data => 'multihomed-server.example.com',
#
# @example
#     dns::record::ptr { '70.128.168.192.IN-ADDR.ARPA':
#       host => '70',
#       zone => '128.168.192.IN-ADDR.ARPA',
#       data => 'multihomed-server.example.com',
#     }

define dns::record::ptr::by_ip (
  $host,
  $zone = undef,
  $ttl = undef,
  $ip = $name,
  $data_dir = $::dns::server::config::data_dir,
) {

  # split the IP address up into three host/zone pairs based on class A, B, or C splits:
  # For IP address A.B.C.D,
  # class C => host D / zone C.B.A.IN-ADDR.ARPA
  # class B => host D.C / zone B.A.IN-ADDR.ARPA
  # class A => host D.C.B / zone A.IN-ADDR.ARPA
  $class_c_zone = inline_template('<%= @ip.split(".").reverse()[1..3].join(".") %>.IN-ADDR.ARPA')
  $class_c_host = inline_template('<%= @ip.split(".").reverse()[0..0].join(".") %>')
  $class_b_zone = inline_template('<%= @ip.split(".").reverse()[2..3].join(".") %>.IN-ADDR.ARPA')
  $class_b_host = inline_template('<%= @ip.split(".").reverse()[0..1].join(".") %>')
  $class_a_zone = inline_template('<%= @ip.split(".").reverse()[3..3].join(".") %>.IN-ADDR.ARPA')
  $class_a_host = inline_template('<%= @ip.split(".").reverse()[0..2].join(".") %>')

  # choose the most specific defined reverse zone file (class C, then B, then A).
  # Default to class C if none are defined.
  if defined(Dns::Zone[$class_c_zone]) {
    $reverse_zone = $class_c_zone
    $octet = $class_c_host
  } elsif defined(Dns::Zone[$class_b_zone]) {
    $reverse_zone = $class_b_zone
    $octet = $class_b_host
  } elsif defined(Dns::Zone[$class_a_zone]) {
    $reverse_zone = $class_a_zone
    $octet = $class_a_host
  } else {
    $reverse_zone = $class_c_zone
    $octet = $class_c_host
  }

  if $zone != undef and $zone != '' {
    if $host == '@' {
      $fqdn = $zone
    } else {
      $fqdn = "${host}.${zone}"
    }
  } else {
    $fqdn = $host
  }

  dns::record::ptr { "${octet}.${reverse_zone}":
    host     => $octet,
    zone     => $reverse_zone,
    ttl      => $ttl,
    data     => $fqdn,
    data_dir => $data_dir,
  }
}
