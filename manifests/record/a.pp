# == Define dns::record::a
#
# Wrapper for dns::record to set an A record, optionally
# also setting a PTR at the same time.
#
define dns::record::a (
  $zone,
  $data,
  $ttl = '',
  $ptr = false,
  $host = $name,
  $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},A,${zone}"

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    data     => $data,
    data_dir => $data_dir,
  }

  if $ptr == 'all' {
    dns::record::ptr::by_ip { $data:
      host     => $host,
      zone     => $zone,
      data_dir => $data_dir,
    }
  } elsif $ptr == 'first' or str2bool($ptr) {
    $ip = inline_template('<%= @data.kind_of?(Array) ? @data.first : @data %>')
    dns::record::ptr::by_ip { $ip:
      host     => $host,
      zone     => $zone,
      data_dir => $data_dir,
    }
  }
}
