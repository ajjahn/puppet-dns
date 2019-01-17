# == Define: dns::record::ns
#
# Wrapper of dns::record to set NS records
#
define dns::record::ns (
  Stdlib::Fqdn $zone,
  Stdlib::Host $host = $name,
  Variant[String, Tuple] $data,
  String $ttl = '',
  Stdlib::Absolutepath $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${host},${zone},NS,${data}"

  validate_legacy(String, 'validate_string', $zone)
  validate_legacy(String, 'validate_string', $data)
  validate_legacy(String, 'validate_string', $host)

  if !is_domain_name($zone) or $zone =~ /^[0-9\.]+$/ {
    fail("Define[dns::record::ns]: NS zone ${zone} must be a valid domain name.")
  }
  # Highest label (top-level domain) must be alphabetic
  if $zone =~ /\./ and $zone !~ /\.[A-Za-z]+$/ {
    fail("Define[dns::record::ns]: NS zone ${zone} must be a valid domain name.")
  }
  # RR data must be a valid hostname, not entirely numeric values
  if !is_domain_name($data) or $data =~ /^[0-9\.]+$/ {
    fail("Define[dns::record::ns]: NS data ${data} must be a valid hostname.")
  }

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'NS',
    data     => $data,
    data_dir => $data_dir,
  }
}
