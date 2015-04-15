# Puppet DNS (BIND9) Module

[![Build Status](https://travis-ci.org/ajjahn/puppet-dns.png?branch=master)](https://travis-ci.org/ajjahn/puppet-dns)

Module for provisioning DNS (bind9)

Tested on Ubuntu 12.04 and CentOS 6.5, patches to support other operating systems are welcome.

This module depends on concat (https://github.com/puppetlabs/puppet-concat).
This module requires the package dnssec-tools. For RHEL/CentOS dnssec-tools can be found in the EPEL repository.

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

Debian example:
```puppet
dns::server::options { '/etc/bind/named.conf.options':
  check_names_master => 'fail',
  check_names_slave  => 'warn',
  forwarders         => [ '8.8.8.8', '4.4.4.4' ],
}
```

RHEL example:
```puppet
dns::server::options { '/etc/named/named.conf.options':
  check_names_master => 'fail',
  check_names_slave  => 'warn',
  forwarders         => [ '8.8.8.8', '4.4.4.4' ],
}
```

### Exported resource patterns

```puppet
node default {
  # Other nodes export an A record for thier hostname
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
* [ITBlogger](https://github.com/itblogger)

## License

This module is released under the MIT license:

* [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)
