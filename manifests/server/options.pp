# == Define: dns::server::options
#
# BIND server template-based configuration definition.
#
# === Parameters
#
# [*allow_recursion*]
#   Array of IP addresses which are allowed to make recursive queries.
#   Default: empty, meaning "localnets; localhost"
#
# [*allow_query*]
#   Array of IP addresses which are allowed to ask ordinary DNS questions.
#   Default: empty, meaning "any"
#
# [*also_notify*]
#   The list of servers to which additional zone-change notifications
#   should be sent.
#   Default: empty, meaning no additional servers
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
# [*control_channel_ip*]
#   String of one ip for which the control api is bound.
#   Default: undef, meaning the control channel is disable,
#            both control_channel_port and control_channel_ip must be defined
#            for the control api to be enabled
#
# [*control_channel_port*]
#   String of one port for which the control api is bound.
#   Default: undef, meaning the control channel is disable
#            both control_channel_port and control_channel_ip must be defined
#            for the control api to be enabled
#
# [*control_channel_allow*]
#   Array of IPs that are allowed to query the controls channel.
#   Default: undef, meaning all IPs that can reach control_channel_ip are allowed
#            to query it
#
# [*data_dir*]
#   Bind data directory.
#   Default: `/etc/bind/zones` in Debian, `/var/named` in RedHat.
#
# [*dnssec_validation*]
#   Controls DNS-SEC validation.  String of "yes", "auto", "no", or
#   "absent" (to prevent the `dnssec-validation` option from being
#   included).  Default is "absent" on RedHat 5 (whose default bind
#   package is too old to include dnssec validation), and "auto" on
#   Debian and on RedHat 6 and above.
#   Note: If *dnssec_enable* is set to false, this option is ignored.
#
# [*dnssec_enable*]
#   Controls whether to enable/disable DNS-SEC support. Boolean.
#   Default is false on RedHat 5 (for the same reasons as
#   dnssec_validation above), and true on Debian and on RedHat 6
#   and above.
#
# [*forward_policy*]
#   The forwarding policy to use.  Must be `first` or `only`.
#   If not defined, the `named` default of `first` will be used.
#
# [*forwarders*]
#   Array of forwarders IP addresses. Default: empty
#
# [*listen_on*]
#   Array of IP addresses on which to listen. Default: empty, meaning "any"
#
# [*listen_on_ipv6*]
#   Array of IPv6 addresses on which to listen. Default: empty, meaning "any"
#
# [*listen_on_port*]:
#   UDP/TCP port number to use for receiving and sending traffic.
#   Default: undefined, meaning 53
#
# [*log_categories*]
#   Logging categories to use. It is a hash of arrays. Each key of the hash is a category
#   and its value is the array of options. If `query_log_enable` is set to true, then
#   this value is ignored.
#   Default: empty.
#
# [*log_channels*]
#   Logging channels to use. It is a hash of arrays. Each key of the hash is a channel
#   and its value is the array of options. If `query_log_enable` is set to true, then
#   this value is ignored.
#   Default: empty.
#
# [*no_empty_zones*]
#   Controls whether to enable/disable empty zones. Boolean values.
#   Default: false, meaning enable empty zones
#
# [*notify_source*]
#   The source IP address from which to send notifies.
#   Default: undef, meaning the primary IP address of the DNS server,
#   as determined by BIND.
#
# [*query_log_enable*]
#   If `true`, query logging will be turned on and directed to the
#   `named_querylog` file in the `working_dir` directory.  If `false`
#   or not defined, query logging will not be configured.
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
# [*statistic_channel_allow*]
#   Array of IPs that are allowed to query the statistics channel.
#   Default: undef, meaning all IPs that can reach statistic_channel_ip are allowed
#            to query it
#
# [*transfers*]
#   Array of IP addresses or "none" allowed to transfer. Default: empty
#
# [*transfer_source*]
#   The source IP address from which to respond to transfer requests.
#   Default: undef, meaning the primary IP address of the DNS server,
#   as determined by BIND.
#
# [*zone_notify*]
#   Controls notifications when a zone for which this server is
#   authoritative changes.  String of yes (send notifications to zone's
#   NS records and to also-notify list), no (no notifications are sent),
#   master-only (only send notifications for master zones), or explicit
#   (send notifications only to also-notify list).
#   Default: undef, meaning the BIND default of "yes"
#
# [*working_dir*]
#   The working directory where the query log will be stored.
#   Default: `/var/cache/bind` in Debian, `${data_dir}/data` in RedHat
#
# [*extra_options* ]
#   Hash with other options that will be included.
#   Default: empty.
#
# === Examples
#
#  dns::server::options { '/etc/bind/named.conf.options':
#    forwarders => [ '8.8.8.8', '8.8.4.4' ],
#   }
#
define dns::server::options (
  $allow_query = [],
  $allow_recursion = [],
  $also_notify = [],
  $check_names_master = undef,
  $check_names_slave = undef,
  $check_names_response = undef,
  $control_channel_ip = undef,
  $control_channel_port = undef,
  $control_channel_allow = undef,
  $data_dir = $::dns::server::params::data_dir,
  $dnssec_validation = $::dns::server::params::default_dnssec_validation,
  $dnssec_enable = $::dns::server::params::default_dnssec_enable,
  $forward_policy = undef,
  $forwarders = [],
  $listen_on = [],
  $listen_on_ipv6 = [],
  $listen_on_port = undef,
  $log_channels = {},
  $log_categories = {},
  $no_empty_zones = false,
  $notify_source = undef,
  $query_log_enable = undef,
  $statistic_channel_ip = undef,
  $statistic_channel_port = undef,
  $statistic_channel_allow = undef,
  $transfers = [],
  $transfer_source = undef,
  $working_dir = $::dns::server::params::working_dir,
  $zone_notify = undef,
  $extra_options = {},
) {
  include dns::server::params
  $valid_check_names = ['fail', 'warn', 'ignore']
  $valid_forward_policy = ['first', 'only']
  $cfg_dir = $::dns::server::params::cfg_dir

  if ! defined(Class['::dns::server']) {
    fail('You must include the ::dns::server base class before using any dns options defined resources')
  }

  validate_string($forward_policy)
  if $forward_policy != undef and !member($valid_forward_policy, $forward_policy) {
    fail("The forward_policy must be ${valid_forward_policy}")
  }
  validate_array($forwarders)
  validate_array($transfers)
  validate_array($listen_on)
  validate_array($listen_on_ipv6)
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

  if $statistic_channel_allow != undef {
    validate_array($statistic_channel_allow)
  }

  if $control_channel_port != undef and !is_numeric($control_channel_port) {
    fail('The control_channel_port is not a number')
  }

  if $control_channel_ip != undef and (!is_string($control_channel_ip) or !is_ip_address($control_channel_ip)) {
    fail('The control_channel_ip is not an ip string')
  }

  if $control_channel_allow != undef {
    validate_array($control_channel_allow)
  }

  validate_array($also_notify)

  $valid_zone_notify = ['yes', 'no', 'explicit', 'master-only']
  if $zone_notify != undef and !member($valid_zone_notify, $zone_notify) {
    fail("The zone_notify must be ${valid_zone_notify}")
  }

  $valid_dnssec_validation = ['yes', 'no', 'auto', 'absent']
  if $dnssec_validation != undef and !member($valid_dnssec_validation, $dnssec_validation) {
    fail("The dnssec_validation must be ${valid_dnssec_validation}")
  }

  validate_bool($no_empty_zones)

  validate_bool($dnssec_enable)
  if (! $dnssec_enable) and ($dnssec_validation != undef) {
    warning('dnssec_enable is false. dnssec_validation will be ignored.')
  }

  if $notify_source != undef and !is_ip_address($notify_source) {
    fail('The notify_source is not an ip string')
  }

  if $transfer_source != undef and !is_ip_address($transfer_source) {
    fail('The transfer_source is not an ip string')
  }

  # validate these, just in case they're overridden
  validate_absolute_path($data_dir)
  validate_absolute_path($working_dir)

  validate_hash($log_channels)
  validate_hash($log_categories)

  validate_hash($extra_options)

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
