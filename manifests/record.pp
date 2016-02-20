# == Define dns::record
#
# This is a private class to arbitary dns records.
#
define dns::record (
  $zone,
  $host,
  $data,
  $record = 'A',
  $dns_class = 'IN',
  $ttl = '',
  $preference = false,
  $order = 9
) {

  $data_dir = $dns::server::params::data_dir

  $zone_file_stage = "${data_dir}/db.${zone}.stage"

  if $ttl !~ /^[0-9SsMmHhDdWw]+$/ and $ttl != '' {
    fail("Define[dns::record]: TTL ${ttl} must be an integer within 0-2147483647 or explicitly specified time units, e.g. 1h30m.")
  }

  if is_integer($ttl) and !(($ttl + 0) >= 0 and ($ttl+ 0) <= 2147483647) {
    fail("Define[dns::record]: TTL ${ttl} must be an integer within 0-2147483647 or explicitly specified time units, e.g. 1h30m.")
  }

  concat::fragment{"db.${zone}.${name}.record":
    target  => $zone_file_stage,
    order   => $order,
    content => template("${module_name}/zone_record.erb")
  }

}
