class dns::server::params {

  case $operatingsystem {
    'CentOS', 'RedHat': {
      $confdir = '/etc'
      $dir = '/etc/named'
      $group = 'named'
      $owner = 'root'
      $package = 'bind'
      $service = 'named'
    }
    'Debian', 'Ubuntu': {
      $dir = '/etc/bind'
      $dir = '/etc/bind'
      $group = 'bind'
      $owner = 'bind'
      $package = 'bind9'
      $service = 'bind9'
    }
  }

}
