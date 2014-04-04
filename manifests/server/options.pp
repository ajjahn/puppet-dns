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
define dns::server::options (
  $forwarders = [],
) {
  include dns::server::params

  file { $title:
    ensure  => present,
    owner   => $dns::server::params::owner,
    group   => $dns::server::params::group,
    mode    => '0644',
    content => template("${module_name}/named.conf.options.erb"),
    require => Class['dns::server::install'],
    notify  => Class['dns::server::service'],
  }

}
