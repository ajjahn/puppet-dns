# == Define: dns::server::options
#
# BIND server template-based configuration definition.
#
# === Parameters
#
# [*forwarders*]
#   Array of forwarders IP addresses. Default: empty
#
# [*transfers*]
#   Array of IP addresses or "none" allowed to transfer. Default: empty
#
# [*listen_on*]
#   Array of IP addresses on which to listen. Default: empty, meaning "any"
#
# [*listen_on_port*]:
#   UDP/TCP port number to use for receiving and sending traffic.
#   Default: undefined, meaning 53
#
# [*allow_recursion*]
#   Array of IP addresses which are allowed to make recursive queries.
#   Default: empty, meaning "localnets; localhost"
#
# [*check_names_master*]
#   Restrict the character set and syntax of master zones.
#   Default: undefined, meaning "fail"
#
# [*check_names_slave*]
#   Restrict the character set and syntax of slave zones.
#   Default: undefined, meaning "warn"
#
# [*check_names_response*]
#   Restrict the character set and syntax of network responses.
#   Default: undefined, meaning "ignore"
#
# [*allow_query*]
#   Array of IP addresses which are allowed to ask ordinary DNS questions.
#   Default: empty, meaning "any"
#
# [*statistic_channel_ip*]
#   String of one ip for which the statistic api is bound.
#   Default: undef, meaning the statistic channel is disable,
#            both statistic_channel_port and statistic_channel_ip must be defined
#            for the statistic api to be enabled
#
# [*statistic_channel_port*]
#   String of one port for which the statistic api is bound.
#   Default: undef, meaning the statistic channel is disable
#            both statistic_channel_port and statistic_channel_ip must be defined
#            for the statistic api to be enabled
#
# [*zone_notify*]
#   Controls notifications when a zone for which this server is
#   authoritative changes.  String of yes (send notifications to zone's
#   NS records and to also-notify list), no (no notifications are sent),
#   master-only (only send notifications for master zones), or explicit
#   (send notifications only to also-notify list).
#   Default: undef, meaning the BIND default of "yes"
#
# [*also_notify*]
#   The list of servers to which additional zone-change notifications
#   should be sent.
#   Default: empty, meaning no additional servers
#
# === Examples
#
#  dns::server::options { '/etc/bind/named.conf.options':
#    forwarders => [ '8.8.8.8', '8.8.4.4' ],
#   }
#
define dns::server::options (
  $forwarders = [],
  $transfers = [],
  $listen_on = [],
  $listen_on_port = undef,
  $allow_recursion = [],
  $check_names_master = undef,
  $check_names_slave = undef,
  $check_names_response = undef,
  $allow_query = [],
  $statistic_channel_ip = undef,
  $statistic_channel_port = undef,
  $zone_notify = undef,
  $also_notify = [],
) {
  $valid_check_names = ['fail', 'warn', 'ignore']
  $cfg_dir = $::dns::server::params::cfg_dir

  if ! defined(Class['::dns::server']) {
    fail('You must include the ::dns::server base class before using any dns options defined resources')
  }

  validate_array($forwarders)
  validate_array($transfers)
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

  if $statistic_channel_port != undef and !is_numeric($statistic_channel_port) {
    fail('The statistic_channel_port is not a number')
  }

  if $statistic_channel_ip != undef and (!is_string($statistic_channel_ip) or !is_ip_address($statistic_channel_ip)) {
    fail('The statistic_channel_ip is not an ip string')
  }

  validate_array($also_notify)
  $valid_zone_notify = ['yes', 'no', 'explicit', 'master-only']
  if $zone_notify != undef and !member($valid_zone_notify, $zone_notify) {
    fail("The zone_notify must be ${valid_zone_notify}")
  }

  file { $title:
    ensure  => present,
    owner   => $::dns::server::params::owner,
    group   => $::dns::server::params::group,
    mode    => '0644',
    require => [File[$cfg_dir], Class['::dns::server::install']],
    content => template("${module_name}/named.conf.options.erb"),
    notify  => Class['dns::server::service'],
  }

}
