# @summary
#     defined type allows you to declare a BIND ACL.
#
# @param [String] ensure
#     ensure the persence or absence of the acl.
# @param [String] aclname
#     the name given to the ACL. This must be unique. This defaults to
#   the namevar.
# @parm [array] data
#     an array of IP addresses or subnets using CIDR notation.
#
# @example
#     dns::acl { 'trusted':
#       ensure => present,
#       data   => [ '10.0.0.0/8', '172.16.2.0/24', ]
#     }
#
define dns::acl (
  String $ensure  = present,
  String $aclname = $name,
  Array $data     = [],
) {
  include dns::server::params

  assert_type(String, $aclname)
  assert_type(Array, $data)

  concat::fragment { "named.conf.local.acl.${name}.include":
    target  => "${dns::server::params::cfg_dir}/named.conf.local",
    order   => 2,
    content => template("${module_name}/acl.erb"),
  }

}
