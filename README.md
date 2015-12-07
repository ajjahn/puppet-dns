# Puppet DNS (BIND9) Module

[![Build Status](https://travis-ci.org/ajjahn/puppet-dns.png?branch=master)](https://travis-ci.org/ajjahn/puppet-dns)

Module for provisioning DNS (bind9)

Supports:

* Ubuntu: 14.04, 12.04
* CentOS: 7.x, 6.x

Patches to support other operating systems are welcome.

This module depends on concat (https://github.com/puppetlabs/puppet-concat).

This module ''will'' overwrite all bind configuration, it is not safe to apply
to a server with an existing bind configuration.

## Installation

Clone this repo to your Puppet modules directory

    git clone git://github.com/ajjahn/puppet-dns.git dns

or

    puppet module install ajjahn/dns

## Usage

Tweak and add the following to your site manifest:

```puppet
node 'server.example.com' {
  include dns::server

  # Forwarders
  dns::server::options { '/etc/bind/named.conf.options':
    forwarders => [ '8.8.8.8', '8.8.4.4' ]
  }

  # Forward Zone
  dns::zone { 'example.com':
    soa         => 'ns1.example.com',
    soa_email   => 'admin.example.com',
    nameservers => ['ns1']
  }

  # Reverse Zone
  dns::zone { '1.168.192.IN-ADDR.ARPA':
    soa         => 'ns1.example.com',
    soa_email   => 'admin.example.com',
    nameservers => ['ns1']
  }

  # A Records:
  dns::record::a {
    'huey':
      zone => 'example.com',
      data => ['98.76.54.32'];
    'duey':
      zone => 'example.com',
      data => ['12.34.56.78', '12.23.34.45'];
    'luey':
      zone => 'example.com',
      data => ['192.168.1.25'],
      ptr  => true; # Creates a matching reverse zone record.  Make sure you've added the proper reverse zone in the manifest.
  }

  # MX Records:
  dns::record::mx {
    'mx,0':
      zone       => 'example.com',
      preference => 0,
      data       => 'ASPMX.L.GOOGLE.com';
    'mx,10':
      zone       => 'example.com',
      preference => 10,
      data       => 'ALT1.ASPMX.L.GOOGLE.com';
  }

  # NS Records:
  dns::record::ns {
    'example.com':
      zone => 'example.com',
      data => 'ns3';
    'delegation-to-ns4-jp-example-net':
      zone => 'example.com',
      host => 'delegated-zone',
      data => 'ns4.jp.example.net.';
  }

  # CNAME Record:
  dns::record::cname { 'www':
    zone => 'example.com',
    data => 'huey.example.com',
  }

  # TXT Record:
  dns::record::txt { 'www':
    zone => 'example.com',
    data => 'Hello World',
  }
}
```

You can also declare forwarders for a specific zone, if you don't have one in the dns::option.

```puppet
dns::zone { 'example.com':
  soa             => 'ns1.example.com',
  soa_email       => 'admin.example.com',
  allow_forwarder => ['8.8.8.8'],
  forward_policy  => 'first',
  nameservers     => ['ns1'],
}
```

You can change the checking of the domain name. The policy can be either warn fail or ignore.

```puppet
dns::server::options { '/etc/bind/named.conf.options':
  check_names_master => 'fail',
  check_names_slave  => 'warn',
  forwarders         => [ '8.8.8.8', '4.4.4.4' ],
}
```

You can enable the report of bind stats trough the `statistics-channels` using:

```puppet
dns::server::options { '/etc/bind/named.conf.options':
  check_names_master     => 'fail',
  check_names_slave      => 'warn',
  forwarders             => [ '8.8.8.8', '4.4.4.4' ],
  statistic_channel_ip   => '127.0.0.1',
  statistic_channel_port => 8053
}
```

### Exported resource patterns

```puppet
node default {
  # Other nodes export an A record for their hostname
  @@dns::record::a { $::hostname:
    zone => $::domain,
    data => $::ipaddress,
  }
}

node 'ns1.xkyle.com' {
  dns::zone { $::domain:
    soa         => $::fqdn,
    soa_email   => "admin.${::domain}",
    nameservers => [ 'ns1' ],
  }
  # Collect all the records from other nodes
  Dns::Record::A <<||>>
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Note: This module is a merge of the work from the following authors:
* [ajjahn](https://github.com/ajjahn/puppet-dns)
* [Danzilio](https://github.com/danzilio)
* [solarkennedy](https://github.com/solarkennedy)

## License

This module is released under the MIT license:

* [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
