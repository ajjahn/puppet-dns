# == Define: dns::record::ns
#
# Wrapper of dns::record to set NS records
#
define dns::record::ns (
  $zone,
  $data,
  $ttl  = '',
  $host = $name ) {

  $alias = "${host},${zone},NS,${data}"

  validate_string($zone)
  validate_string($data)
  validate_string($host)

  # Check corrected ns zone
  $check_parameter_reverse = getparam(Dns::Zone[$zone], 'reverse')
  if $check_parameter_reverse != 'reverse' and $check_parameter_reverse != true and !is_domain_name($zone) {
    fail("Define[dns::record::ns]: NS zone ${zone} must be a valid domain name.")
  }
  if $check_parameter_reverse != 'reverse' and $check_parameter_reverse != true and $zone =~ /^[0-9\.]+$/ {
    fail("Define[dns::record::ns]: NS zone ${zone} must be a valid domain name.")
  }
  if ( $check_parameter_reverse == 'reverse' or $check_parameter_reverse == true ) and $zone !~ /^((25[0-5]\.|2[0-4][0-9]\.|[01]?[0-9][0-9]?\.){2}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?){1}|(25[0-5]\.|2[0-4][0-9]\.|[01]?[0-9][0-9]?\.){1}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?){1}|(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?){1})$/ {
    fail("Define[dns::record::ns]: NS zone ${zone} PTR, when parameter 'reverse' of zone '${zone}' is not false, must be included octets with separator dot!")
  }
  # Highest label (top-level domain) must be alphabetic
  if $check_parameter_reverse != 'reverse' and $check_parameter_reverse != true and $zone =~ /\./ and $zone !~ /\.[A-Za-z]+$/ {
    fail("Define[dns::record::ns]: NS zone ${zone} must be a valid domain name.")
  }
  # RR data must be a valid hostname, not entirely numeric values
  if !is_domain_name($data) or $data =~ /^[0-9\.]+$/ {
    fail("Define[dns::record::ns]: NS data ${data} must be a valid hostname.")
  }

  dns::record { $alias:
    zone   => $zone,
    host   => $host,
    ttl    => $ttl,
    record => 'NS',
    data   => $data
  }
}
