# == Define: dns::server::startup
#
# BIND server template-based configuration definition.
#
# === Parameters
#
# $startup_file
# Must be an absolute path to the bind9 file as title
#
# [*resolvconf*]
#   Set string "yes" or "no". Default: no
#
# [*options*]
#   String to set user and IPv4/IPv& Support. Default: -u bind
#
# [*rootdir*]
#   Must be an absolute path to set up the chroot environment
# 
# [*enable_zone_write*]
#   If SELinux is disabled, then allow named to write its zone files
#   Set string "yes", "no" or leave empty. Default: empty
#
# [*enable_sdb]
#   Enables use of 'named_sdb', which has support for the ldap
#   Set string "yes", "no" or leave empty. Default: empty
#
# [*keytab_file*]
#   Must be an absolute path to set up the keytab file
#
# [*disable_zone_checking*]
#   If you set this option to 'yes' then initscript doesn't perform named-checkzone
#   Set string "yes", "no" or leave empty. Default: empty
#
# === Examples
#
#  dns::server::startup { '/etc/default/bind9':
#    resolvconf => 'no',
#    options    => '-u bind'
#  }
#
class dns::server::startup (

  $startup_file          = $dns::server::params::startup_file,
  $startup_template      = $dns::server::params::startup_template,

  $resolvconf            = undef,
  $options               = undef,
  $rootdir               = undef,
  $enable_zone_write     = undef,
  $enable_sdb            = undef,
  $disable_named_dbus    = undef,
  $keytab_file           = undef,
  $disable_zone_checking = undef,

) inherits dns::server::params {

  if ! defined(Class['::dns::server']) {
    fail('You must include the ::dns::server base class before using any dns default defined resources')
  }

  validate_absolute_path( $startup_file )

  validate_re( $resolvconf, '^(yes|no)$', 'The resolvconf value is not type of a string yes / no.' )

  if $rootdir != "" {
    validate_absolute_path( $rootdir )
  }

  validate_re( $enable_zone_write, '^(yes|no|\s*)$', 'The enable_zone_write value is not type of a string yes / no or empty.' )

  validate_re( $enable_sdb, '^(yes|no|\s*)$' )

  if $keytab_file != '' {
    validate_absolute_path( $keytab_file )
  }

  validate_re( $disable_zone_checking, '^(yes|no|\s*)$', "The disable_zone_checking value is not type of a string yes / no or empty." )

  file { $startup_file:
    ensure  => present,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template("${module_name}/${startup_template}"),
    notify  => Class['dns::server::service'],
  }

}