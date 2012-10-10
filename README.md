# Puppet DNS (BIND9) Module

Module for provisioning DNS (bind9)

Tested on Ubuntu 12.04, patches to support other operating systems are welcome.

This module depends on concat (https://github.com/ripienaar/puppet-concat).

## Installation

Clone this repo to your Puppet modules directory

    git clone git://github.com/ajjahn/puppet-dns.git dns

## Usage

Tweak and add the following to your site manifest:

    node 'server.example.com' {
      include dns::server

      # Forward Zone
      dns::zone { 'example.com':
        soa => "ns1.example.com",
        soa_email => 'admin.example.com',
        nameservers => ["ns1"]
      }

      # Reverse Zone
      dns::zone { '1.168.192.IN-ADDR.ARPA':
        soa => "ns1.example.com",
        soa_email => 'admin.example.com',
        nameservers => ["ns1"]
      }

      # A Records:
      dns::record::a {
        'huey':
          zone => 'example.com',
          data => ["98.76.54.32"];
        'duey':
          zone => 'example.com',
          data => ["12.34.56.78", "12.23.34.45"];
        'luey':
          zone => 'example.com',
          data => ["192.168.1.25"],
          ptr => true; # Creates a matching reverse zone record.  Make sure you've added the proper reverse zone in the manifest.
      }

      # MX Records:
      dns::record::mx {
        'mx,0':
          zone => 'example.com',
          preference => 0,
          data => 'ASPMX.L.GOOGLE.com';
        'mx,10':
          zone => 'example.com',
          preference => 10,
          data => 'ALT1.ASPMX.L.GOOGLE.com';
      }

      # CNAME Record:
      dns::record::cname {'www':
        zone => 'example.com',
        data => 'huey.example.com',
      }

      # TXT Record:
      dns::record::txt {'www':
        zone => 'example.com',
        data => 'Hello World',
      }
    }

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

This module is released under the MIT license:

* [http://www.opensource.org/licenses/MIT](http://www.opensource.org/licenses/MIT)