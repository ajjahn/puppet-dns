define key {

  package {'dnssec-tools':
    ensure => installed,
  }

  file {'/etc/bind/bind.keys.d':
    ensure => directory,
    require => Package['bind9'],
    notify  => Exec['dnssec-keygen-dhcp-updater'],
  }
  file {'/etc/bind/bind.keys.d/get_secret.sh':
    ensure => file,
    require => File["/etc/bind/bind.keys.d"],
    content => '#!/bin/bash
SECRET=`cat Kdhcp-updater.+157+*.key |tr -s " "|cut -d " " -f7`

cat << EOF > /etc/bind/rndc.key
key "keyname." {
  algorithm hmac-md5;
  secret "$SECRET";
};
EOF',
  }



  exec {'dnssec-keygen-dhcp-updater':
    command     => "/usr/sbin/dnssec-keygen -a HMAC-MD5 -r /dev/urandom -b 128 -n USER ${name}",
    cwd         => '/etc/bind/bind.keys.d',
    require     => [Package['dnssec-tools','bind9'],File['/etc/bind/bind.keys.d']],
    refreshonly => true,
  }
  exec {'get-secret-from-dhcp-updater':
    command => '/etc/bind/bind.keys.d/get_secret.sh',
    cwd         => '/etc/bind/bind.keys.d',
    require     => [Package['dnssec-tools','bind9'],File['/etc/bind/bind.keys.d']],
    refreshonly => true,
  }

