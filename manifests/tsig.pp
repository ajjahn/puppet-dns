# defined type allows you to declare a BIND TSIG.
#
# Parameters:
#
# $ensure = ensure the persence or absence of the acl.
# $keyname = the name given to the TSIG KEY. This must be unique. This defaults to
#   the namevar.
# $algorithm = Defined algorithm of the key (default: hmac-md5)
# $server = related string or array of ip addresses to this key
# $secret = shared secret of the key
#
# Usage:
#
# dns::tsig { 'ns3':
#   ensure => present,
#   algorithm => "hmac-md5"
#   secret    => "dTIxGBPjkT/8b6BYHTUA=="
# }
#
define dns::tsig (
  $keyname   = $name,
  $algorithm = 'hmac-md5',
  $server    = undef,
  $secret    = undef,
  $ensure    = present
) {

  $cfg_dir   = $dns::server::params::cfg_dir # Used in a template
  validate_string($name)

  if $ensure == present {
    concat::fragment { "named.conf.local.tsig.${name}.include":
      target  => "${cfg_dir}/named.conf.local",
      order   => 4,
      content => template("${module_name}/tsig.erb"),
    }
  }

}
