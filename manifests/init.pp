# == Class dns
#
# Currently does nothing
#
class dns {
  # include dns::install
  # include dns::config
  # include dns::service
}

# == Definition: dns_reverse_ptr_record
#
# This is a private type defined to allow the dns::record::a
# defined resource type to create reverse ptr records for hosts
# with multiple ip addresses.
#
# === Parameters
#
# * `$ip`
# The ip address for the ptr record.  Defaults to the resource title.
#
# * `$host`
# The (unqualified) host pointed to by this ptr record.
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
#     dns_reverse_ptr_record { '192.168.128.42':
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
#     dns_reverse_ptr_record { [ '192.168.128.68', '192.168.128.69', '192.168.128.70' ]:
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

define dns_reverse_ptr_record (
  $host,
  $zone,
  $ip = $name ) {

  $reverse_zone = inline_template('<%= @ip.split(".")[0..-2].reverse.join(".") %>.IN-ADDR.ARPA')
  $octet = inline_template('<%= @ip.split(".")[-1] %>')

  dns::record::ptr { "${octet}.${reverse_zone}":
    host => $octet,
    zone => $reverse_zone,
    data => "${host}.${zone}"
  }
}
