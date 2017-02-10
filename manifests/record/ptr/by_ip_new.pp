# Like dns::record::ptr::by_ip, except you pass "${host}.${zone}" as `host` only.

define dns::record::ptr::by_ip_new (
  $host,
  $ttl = undef ,
  $ip = $name ) {

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

  dns::record::ptr { "${octet}.${reverse_zone}":
    host => $octet,
    zone => $reverse_zone,
    ttl  => $ttl ,
    data => "${host}"
  }
}
