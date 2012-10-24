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

  concat::fragment{"db.${zone}.${name}.record":
    target  => "/etc/bind/db.${zone}",
    order   => $order,
    content => template("${module_name}/zone_record.erb")
  }

}
