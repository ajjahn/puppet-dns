# == Class: dns::server::default
#
class dns::server::default (

  $default_file = $dns::server::params::default_file,
  $default_template = $dns::server::params::default_template,
  Optional[String] $resolvconf = undef,
  $options = undef,
  Optional[String] $rootdir = undef,
  Optional[String] $enable_zone_write = undef,
  Optional[String] $enable_sdb = undef,
  $disable_named_dbus = undef,
  Optional[String] $keytab_file = undef,
  Optional[String] $disable_zone_checking = undef,

) inherits dns::server::params {

  validate_absolute_path($default_file)

  if $resolvconf != undef {
    assert_type(Pattern[/(^yes|no)$/], $resolvconf) | $a, $b| {
      fail('The resolvconf value is not type of a string yes / no.' )
    }
  }

  if $rootdir != undef {
    validate_absolute_path( $rootdir )
  }

  if $enable_zone_write != undef {
  #  assert_type(Pattern[/(^yes|no|\s*)$/], $enable_zone_write) | $a, $b| {
  #    fail( 'The enable_zone_writing value is not type of a string yes / no or empty.' )
  #  }
     validate_re( $enable_zone_write, '^(yes|no|\s*)$', 'The enable_zone_write value is not type of a string yes / no or empty.' )
  }

  if $enable_sdb != undef {
  #  assert_type(Pattern[/(^yes|no|\s*)$/], $enable_sdb) | $a, $b| {
  #    fail( 'The enable_sdb value is not type of a string yes / no or empty.' )
  #  }
    validate_re( $enable_sdb, '^(yes|no|1|0|\s*)$', 'The enable_sdb value is not type of a string yes / no / 1 / 0 or empty.' )
  }

  if $keytab_file != undef {
    validate_absolute_path( $keytab_file )
  }

  if $disable_zone_checking != undef {
    #assert_type(Pattern[/(^yes|no|\s*)$/], $disable_zone_checking) | $a, $b| {
    #  fail( 'The disable_zone_checking value is not type of a string yes / no or empty.' )
    #}
    validate_re( $disable_zone_checking, '^(yes|no|\s*)$', 'The disable_zone_checking value is not type of a string yes / no or empty.' )
  }

  file { $default_file:
    ensure  => present,
    owner   => $::dns::server::params::owner,
    group   => $::dns::server::params::group,
    mode    => '0644',
    content => template("${module_name}/${default_template}"),
    notify  => Class['dns::server::service'],
    require => Package[$::dns::server::params::necessary_packages]
  }

}
