# == Define dns::record
#
# @api private
#    This is a private class to arbitary dns records.
#
define dns::record (
  Variant[String, Tuple] $zone,
  Variant[Stdlib::Host, String] $host,
  Variant[String, Tuple] $data,
  String $record = 'A',
  String $dns_class = 'IN',
  Variant[String, Integer] $ttl = '',
  Variant[Boolean, Integer] $preference = false,
  Integer $order = 9,
  Stdlib::Absolutepath $data_dir = $::dns::server::params::data_dir,
) {

  $zone_file_stage = "${data_dir}/db.${zone}.stage"

  # lint:ignore:only_variable_string
  if "${ttl}" !~ /^[0-9SsMmHhDdWw]+$/ and $ttl != '' {
  # lint:endignore:only_variable_string
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
