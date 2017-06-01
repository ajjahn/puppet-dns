# == Define dns::server::view
#
# `dns::server::view` defines a DNS view.
#
# Zones to the view could be added by using the `zones` parameter of
# `dns::server::view` or by declaring `dns::zone` resources with its `view`
# parameter set to this resource name.
#
# === Parameters
#
# [*ensure*]
#   If the view should be `present` or `absent. Defaults to `present`.
#
# [*enable_default_zones*]
#   Boolean indicating if the default zones (`named.conf.default-zones`) should
#   be included in this view or not. Defaults to `true`.
#
# [*match_clients*]
#   Array (of strings) with the `match-clients` for the zone. Defaults to empty.
#
# [*match_destinations*]
#   Array (of strings) with the `match-destinations` for the view. Defaults to empty.
#
# [*match_recursive_only*]
#   Value for the `match-recursive-only` option of the view. Defaults to undef
#   (the option is not configured). Valid values are `yes` and `no`.
#
# [*options* ]
#   Hash with additional options that should be configured in the view.
#   Defaults to empty (no additional option is added). It should be a hash where
#   every value should be a string or an array.
#
# [*order*]
#   Order of different views could be important (for example, if `match_clients`
#   of a view is a superset of the `match_clients` of another). This parameter
#   could be used to force a different order of the alphatical one.
#   Defaults to `50`.
#
# [*viewname*]
#   Name of the view. Defaults to `$name`.
#
# [*zones*]
#   Hash of zones resources that should be included in this view.
#   Defaults to empty (no zone is added).
#
define dns::server::view (
  $ensure               = 'present',
  $enable_default_zones = true,
  $match_clients        = [],
  $match_destinations   = [],
  $match_recursive_only = undef,
  $options              = {},
  $order                = '50',
  $viewname             = $name,
  $zones                = {},
) {
  include ::dns::server::params

  $valid_ensure = ['present', 'absent']
  $valid_yes_no = ['yes', 'no']
  if !member($valid_ensure, $ensure) {
    fail("ensure parameter must be ${valid_ensure}")
  }
  validate_bool($enable_default_zones)
  validate_array($match_clients)
  validate_array($match_destinations)
  if $match_recursive_only {
    if !member($valid_yes_no, $match_recursive_only) {
      fail("match_recursive_only parameter must be ${valid_yes_no}")
    }
  }
  validate_hash($options)
  validate_string($order)
  validate_string($viewname)
  validate_hash($zones)

  $rfc1912_zones_cfg = $dns::server::params::rfc1912_zones_cfg

  concat { "${dns::server::params::cfg_dir}/view-${name}.conf":
    ensure         => $ensure,
    owner          => $dns::server::params::owner,
    group          => $dns::server::params::group,
    mode           => '0644',
    ensure_newline => true,
    notify         => Class['dns::server::service'],
  }

  if $ensure == 'present' {
    concat::fragment {"view-${name}.header":
      target  => "${dns::server::params::cfg_dir}/view-${name}.conf",
      order   =>  '00',
      content => template("${module_name}/view.erb"),
    }

    concat::fragment {"view-${name}.tail":
      target  => "${dns::server::params::cfg_dir}/view-${name}.conf",
      order   => '99',
      content => '}; ',
    }

    # Include view configuration in main config
    concat::fragment {"named.conf.local.view.${name}.include":
      target  => "${dns::server::params::cfg_dir}/named.conf.local",
      order   => $order,
      content => "include \"${dns::server::params::cfg_dir}/view-${name}.conf\";\n",
      require => Concat["${dns::server::params::cfg_dir}/view-${name}.conf"],
    }

    # Create zone config
    create_resources(dns::zone, $zones, { view => $name })
  }
}
