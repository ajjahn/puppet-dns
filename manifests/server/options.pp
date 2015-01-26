# Define: dns::server::options
#
# BIND server template-based configuration definition.
#
# Parameters:
# $forwarders:
#   Array of forwarders IP addresses. Default: empty
# $listen_on:
#   Array of IP addresses on which to listen. Default: empty, meaning "any"
# $listen_on_port:
#   UDP/TCP port number to use for receiving and sending traffic.  Default: undefined, meaning 53
# $group:
#   Group of the file. Default: bind
# $owner:
#   Owner of the file. Default: bind
#
# Sample Usage :
#  dns::server::options { '/etc/bind/named.conf.options':
#    forwarders => [ '8.8.8.8', '8.8.4.4' ],
#   }
#
define dns::server::options(
  $forwarders = [],
  $listen_on = [],
  $listen_on_port = undef,
  $allow_recursion = [],
  $check_names_master = undef,
  $check_names_slave = undef,
  $check_names_response = undef,
  $allow_query = [],
) {
  $valid_check_names = ['fail', 'warn', 'ignore']

  if ! defined(Class['::dns::server']) {
    fail('You must include the ::dns::server base class before using any dns options defined resources')
  }

  validate_array($forwarders)
  validate_array($listen_on)
  validate_array($allow_recursion)
  if $check_names_master != undef and !member($valid_check_names, $check_names_master) {
    fail("The check name policy check_names_master must be ${valid_check_names}")
  }
  if $check_names_slave != undef and !member($valid_check_names, $check_names_slave) {
    fail("The check name policy check_names_slave must be ${valid_check_names}")
  }
  if $check_names_response != undef and !member($valid_check_names, $check_names_response) {
    fail("The check name policy check_names_response must be ${valid_check_names}")
  }
  validate_array($allow_query)

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
