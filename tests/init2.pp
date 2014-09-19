  include dns::server
  $nodes = hiera("instances")
  
  #Forward Zone
  dns::zone { 'mtd.ksu':
    soa => "$hostname.mtd.ksu",
    soa_email => 'admin.mtd.ksu',
    nameservers => ["$hostname"]
  }

  #Reverse Zone
  $i1 = regsubst($ipaddress,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\1')
  $i2 = regsubst($ipaddress,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\2')
  $i3 = regsubst($ipaddress,'^(\d+)\.(\d+)\.(\d+)\.(\d+)$','\3')
  dns::zone { "$i3.$i2.$i1.IN-ADDR.ARPA":
    soa => "$hostname.mtd.ksu",
    soa_email => 'admin.mtd.ksu',
    nameservers => ["$hostname"]
  }

  #A Records:
  define dns_record_a ($ip_address) {
  dns::record::a { "$name":
      zone => 'mtd.ksu',
      data => ["$ip_address"],
      ptr => true;
     }
   }
  
  
  # NS Records:
  dns::record::ns {'mtd.ksu':
      zone => 'mtd.ksu',
      data => "$hostname.mtd.ksu.";
  }
  create_resources(dns_record_a, $nodes)
}
