node 'testhost.example.com' {

  include dns::server

  dns::zone { 'example.com':
    soa         => 'ns1.example.com',
    soa_email   => 'admin.example.com',
    nameservers => [ 'ns1.example.com', ]
  }
  dns::zone { '1.168.192.IN-ADDR.ARPA':
    soa         => 'ns1.example.com',
    soa_email   => 'admin.example.com',
    nameservers => [ 'ns1.example.com', ]
  }
  dns::record::a { 'ns1':
    zone => 'example.com',
    data => [ '192.168.1.1', ],
    ptr  => true;
  }
}

node default {}