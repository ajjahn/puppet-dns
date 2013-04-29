define dns::record::ptr (
  $zone,
  $data,
  $ttl = '',
  $host = $name ) {

  if $host =~ /IN-ADDR.ARPA$/ {
    $hostdata = inline_template('<%= host.split(".")[0]%>')
  } else {
    $hostdata = $host
  }
  
  $alias = "${host},PTR,${zone}"

  dns::record { $alias:
    zone   => $zone,
    host   => $hostdata,
    ttl    => $ttl,
    record => 'PTR',
    data   => "${data}."
  }
}
