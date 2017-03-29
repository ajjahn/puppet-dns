# == Define dns::record::txt
#
# Wrapper for dns::record for TXT records
#
# === Parameters
#
# [*zone*]
#   The zone in which this record should be created.
# [*data*]
#   The value of the TXT record.  (See the @Formatting section below)
# [*ttl*]
#   The time-to-live value for the record.  Defaults to an empty string,
#   which means BIND will use the zone's TTL setting.
# [*host*]
#   The host name for this record.  Defaults to the resource title.
#
# === Formatting
#
# DNS `TXT` and `SPF` records have specific formatting applied to their
# *data* values, based on the requirements in
# [RFC1035](https://tools.ietf.org/html/rfc1035.html) sections
# [3.3](https://tools.ietf.org/html/rfc1035.html#section-3.3),
# [3.3.14](https://tools.ietf.org/html/rfc1035.html#section-3.3.14), and
# [5](https://tools.ietf.org/html/rfc1035.html#section-5).
#
# When the `TXT` or `SPF` record is created in the zone file, the data
# value will be split into multiple strings of no more than 255 characters
# each; within each character string, double-quotes (`"`) and backslashes
# (`\\`) will be escaped by adding a backslash before them (`\\#` / `\\\\`);
# each individual string will be surrounded by double-quotes; and the strings
# will be joined back together with spaces in between.
#
# === Examples
#
#     dns::record::txt { 'txt1':
#         zone => 'example.com',
#         data => 'this is a test record',
#     }
#
# will generate:
#
#     txt1            IN      TXT     "this is a test record"
#
# ---
#
#     dns::record::txt { 'txt2':
#         zone => 'example.com',
#         data => 'this is "another" test record',
#     }
#
# will generate:
#
#     txt2            IN      TXT     "this is \"another\" test record"
#
# ---
#
#     dns::record::txt { 'txt3.example.com':
#         zone => 'example.com',
#         data => 'this is a' + ' very'*60 + ' long test record',
#         host => 'txt3',
#     }
#
# will generate:
#
#     txt3            IN      TXT     "this is a very very very...very " "very very...very long test record"
#

define dns::record::txt (
  $zone,
  $data,
  $ttl = '',
  $host = $name,
  $data_dir = $::dns::server::config::data_dir,
) {

  $alias = "${name},TXT,${zone}"

  dns::record { $alias:
    zone     => $zone,
    host     => $host,
    ttl      => $ttl,
    record   => 'TXT',
    data     => $data,
    data_dir => $data_dir,
  }
}
