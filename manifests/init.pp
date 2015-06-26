# == Class dns
#
# Currently does nothing
#
class dns {
  # include dns::install
  # include dns::config
  # include dns::service
  include dns::server::default
}
