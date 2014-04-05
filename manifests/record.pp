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

  $zone_file_data = "${cfg_dir}/zones/db.${zone}.data"

  concat::fragment{"db.${zone}.${name}.record":
    target  => $zone_file_data,
    order   => $order,
    content => template("${module_name}/zone_record.erb")
  }

}
