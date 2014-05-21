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

  $cfg_dir = $dns::server::params::cfg_dir

  $zone_file_stage = "${cfg_dir}/zones/db.${zone}.stage"

  concat::fragment{"db.${zone}.${name}.record":
    target  => $zone_file_stage,
    order   => $order,
    content => template("${module_name}/zone_record.erb")
  }

}
