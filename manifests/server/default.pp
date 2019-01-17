# == Class: dns::server::default
#
class dns::server::default (

  Stdlib::Absolutepath $default_file = $dns::server::params::default_file,
  String $default_template = $dns::server::params::default_template,
  Optional[String] $resolvconf = undef,
  $options = undef,
  Optional[Variant[Undef, String, Stdlib::Absolutepath]] $rootdir = undef,
  # Moving to String will validate RSPEC
  # Optional[String] $rootdir = undef,
  # Optional[String] $enable_zone_write = undef,
  Optional[Variant[Undef, String, Enum['yes','no']]] $enable_zone_write = undef,
  Optional[String] $enable_sdb = undef,
  # $disable_named_dbus = undef,
  Optional[Variant[Undef, String, Enum['yes','no']]] $disable_named_dbus = undef,
  Optional[String] $keytab_file = undef,
  Optional[String] $disable_zone_checking = undef,

) inherits dns::server::params {
  # TODO: Fix validation of absolutepath
  # validate_legacy(String[Stdlib::Absolutepath], $default_file)
  # validate_absolute_path($default_file)
  # if ($default_file) =~ Stdlib::Absolutepath) {
  #  fail("String values aren't allowed")
  #}

  if $resolvconf != undef {
    assert_type(Pattern[/(^yes|no)$/], $resolvconf) | $a, $b| {
      fail('The resolvconf value is not type of a string yes / no.' )
    }
  }

  if $rootdir != undef {
  # TODO: Fix validation of absolutepath
  #  validate_legacy(String[Stdlib::Absolutepath], $rootdir)
    validate_absolute_path( $rootdir )
  }

  if $enable_zone_write != undef {
  # TODO: This needs work as it currently won't pass the unit tests
  # assert_type(Pattern[/(^yes|no|\s*)$/], $enable_zone_write) | $a, $b| {
  #    fail( 'The enable_zone_writing value is not type of a string yes / no or empty.' )
  #  }
    validate_re( $enable_zone_write, '^(yes|no|\s*)$', 'The enable_zone_write value is not type of a string yes / no or empty.' )
  }

  if $enable_sdb != undef {
  # TODO: This needs work as it currently won't pass the unit tests
  #  assert_type(Pattern[/(^yes|no|\s*)$/], $enable_sdb) | $a, $b| {
  #    fail( 'The enable_sdb value is not type of a string yes / no or empty.' )
  #  }
    validate_re( $enable_sdb, '^(yes|no|1|0|\s*)$', 'The enable_sdb value is not type of a string yes / no / 1 / 0 or empty.' )
  }

  if $keytab_file != undef {
  # TODO: Fix validation of absolute path
  #  validate_legacy(String[Stdlib::Absolutepath], $keytab_file)
    validate_absolute_path( $keytab_file )
  }

  if $disable_zone_checking != undef {
  # TODO: This needs work as it currently won't pass the unit tests
  # assert_type(Pattern[/(^yes|no|\s*)$/], $disable_zone_checking) | $a, $b| {
  #  fail( 'The disable_zone_checking value is not type of a string yes / no or empty.' )
  # }
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
