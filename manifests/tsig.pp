# @summary
#     defined type allows you to declare a BIND TSIG.
#
# @param [String] ensure
#     ensure the persence or absence of the acl.
# @param [String] keyname
#     the name given to the TSIG KEY. This must be unique.
#     This defaults to the namevar.
# @param [String] algorithm
#     Defined algorithm of the key (default: hmac-md5)
# @param [String] server
#     related string or array of ip addresses to this key
# @param [String] secret
#     shared secret of the key
#
# @example
#     dns::tsig { 'ns3':
#       ensure    => present,
#       algorithm => "hmac-md5"
#       secret    => "dTIxGBPjkT/8b6BYHTUA=="
#     }
#
define dns::tsig (
  String $keyname = $name,
  String $algorithm = 'hmac-md5',
  Variant[Undef, String, Array] $server = undef,
  Variant[Undef, String] $secret = undef,
  String $ensure = 'present',
) {

  $cfg_dir   = $dns::server::params::cfg_dir # Used in a template

  assert_type(String, $name)

  if $ensure == 'present' {
    concat::fragment { "named.conf.local.tsig.${name}.include":
      target  => "${cfg_dir}/named.conf.local",
      order   => 4,
      content => template("${module_name}/tsig.erb"),
    }
  }

}
