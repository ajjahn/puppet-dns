# Define: dns::server::options
#
# BIND server template-based configuration definition.
#
# Parameters:
#  $forwarders:
#   Array of forwarders IP addresses. Default: empty
# $group:
#   Group of the file. Default: bind
# $owner:
#   Owner of the file. Default: bind
#
# Sample Usage :
#  dns::server::options { '/etc/bind/named.conf.options':
#    'forwarders' => [ '8.8.8.8', '8.8.4.4' ],
#   }
#
define dns::server::options(
  $forwarders = [],
) {

  if ! defined(Class['::dns::server']) {
    fail('You must include the ::dns::server base class before using any dns options defined resources')
  }

  validate_array($forwarders)

  file { $title:
    ensure  => present,
    owner   => $::dns::server::params::owner,
    group   => $::dns::server::params::group,
    mode    => '0644',
    require => [File[$::dns::server::params::cfg_dir], Class['::dns::server::install']],
    content => template("${module_name}/named.conf.options.erb"),
    notify  => Class['::dns::server::service'],
  }

}
