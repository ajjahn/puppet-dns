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

  $zone_file_data = "/etc/bind/db.${zone}.data"

  concat::fragment{"db.${zone}.${name}.record":
    target  => $zone_file_data,
    order   => $order,
    content => template("${module_name}/zone_record.erb")
  }

}
