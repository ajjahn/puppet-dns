class dns::server {
  include dns::server::install
  include dns::server::config
  include dns::server::service
}