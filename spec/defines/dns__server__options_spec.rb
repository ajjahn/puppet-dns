require 'spec_helper'

describe 'dns::server::options', :type => :define do
  let :pre_condition do
    'class { "::dns::server": }'
  end

  let(:facts) { { :osfamily => 'Debian', :concat_basedir => '/tmp' } }

  let(:title) { '/etc/bind/named.conf.options' }

  context 'passing valid array to forwarders' do
    let :params do
      { :forwarders => [ '8.8.8.8', '4.4.4.4' ] }
    end
    it { should contain_file('/etc/bind/named.conf.options') }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/8\.8\.8\.8;$/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/4\.4\.4\.4;$/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_ensure("present")  }
    it { should contain_file('/etc/bind/named.conf.options').with_owner("bind") }
    it { should contain_file('/etc/bind/named.conf.options').with_group("bind") }
  end

  context 'passing valid array to transfers' do
    let :params do
      { :transfers => ['192.168.0.3', '192.168.0.4'] }
    end
    it { should contain_file('/etc/bind/named.conf.options') }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/192\.168\.0\.3;$/) }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/192\.168\.0\.4;$/) }
    it { should contain_file('/etc/bind/named.conf.options').with_ensure("present") }
    it { should contain_file('/etc/bind/named.conf.options').with_owner("bind") }
    it { should contain_file('/etc/bind/named.conf.options').with_group("bind") }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/allow-transfer/) }
  end

  context 'passing a string to forwarders' do
    let :params do
      { :forwarders => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing a string to transfers' do
    let :params do
      { :transfers => '192.168.0.3' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing valid array to listen_on' do
    let :params do
      { :listen_on => [ '10.11.12.13', '192.168.1.2' ] }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/10\.11\.12\.13;$/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/192\.168\.1\.2;$/)  }
  end

  context 'passing custom port to listen_on_port' do
    let :params do
      { :listen_on_port => 5300 }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/port 5300;/)  }
  end

  context 'passing a string to listen_on' do
    let :params do
      { :listen_on => '10.9.8.7' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing a string to recursion' do
    let :params do
      { :allow_recursion => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing a valid recursion allow range' do
    let :params do
      { :allow_recursion => ['10.0.0.1'] }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/10\.0\.0\.1;$/) }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/allow-recursion \{$/) }
  end

  context 'passing a wrong string to slave name' do
    let :params do
      { :check_names_slave => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /The check name policy/) }
  end

  context 'passing a wrong string to master name' do
    let :params do
      { :check_names_master => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /The check name policy/) }
  end

  context 'passing a wrong string to response name' do
    let :params do
      { :check_names_response => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /The check name policy/) }
  end

  context 'passing a valid string to a check name' do
    let :params do
      { :check_names_master => 'warn',
       :check_names_slave => 'ignore',
       :check_names_response => 'warn',
      }
    end
    it { should contain_file('/etc/bind/named.conf.options') }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/check-names master warn;/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/check-names slave ignore;$/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/check-names response warn;$/)  }
  end

  context 'passing no string to check name' do
    it { should contain_file('/etc/bind/named.conf.options').without_content(/check-names master/)}
    it { should contain_file('/etc/bind/named.conf.options').without_content(/check-names slave/)}
    it { should contain_file('/etc/bind/named.conf.options').without_content(/check-names response/)}
  end

  context 'passing a string to the allow query' do
    let :params do
      { :allow_query => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing a valid array to the allow query' do
    let :params do
      { :allow_query => ['8.8.8.8'] }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/8\.8\.8\.8;/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/allow-query/)  }
  end

  context 'passing no statistic channel ip' do
    let :params do
      {}
    end
    it { should_not contain_file('/etc/bind/named.conf.options').with_content(/statistics-channels/)  }
  end

  context 'passing a valid ip and a valid port' do
    let :params do
      { :statistic_channel_ip => '127.0.0.1',
        :statistic_channel_port => 12455 }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/statistics-channels/)  }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/inet 127\.0\.0\.1 port 12455;/)  }
  end

  context 'passing no zone_notify setting' do
    let :params do
      {}
    end
    it { should contain_file('/etc/bind/named.conf.options').without_content(/^notify /) }
  end

  context 'passing a wrong zone_notify setting' do
    let :params do
      { :zone_notify => 'maybe' }
    end
    it { should raise_error(Puppet::Error, /The zone_notify/) }
  end

  context 'passing yes to zone_notify' do
    let :params do
      { :zone_notify => 'yes' }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify yes;/) }
  end

  context 'passing no to zone_notify' do
    let :params do
      { :zone_notify => 'no' }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify no;/) }
  end

  context 'passing master-only to zone_notify' do
    let :params do
      { :zone_notify => 'master-only' }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify master-only;/) }
  end

  context 'passing explicit to zone_notify' do
    let :params do
      { :zone_notify => 'explicit' }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/^notify explicit;/) }
  end

  context 'passing no also_notify setting' do
    let :params do
      {}
    end
    it { should contain_file('/etc/bind/named.conf.options').without_content(/^also-notify /) }
  end

  context 'passing a string to also_notify' do
    let :params do
      { :also_notify => '8.8.8.8' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing a valid array to also_notify' do
    let :params do
      { :also_notify => [ '8.8.8.8' ] }
    end
    it { should contain_file('/etc/bind/named.conf.options').with_content(/^also-notify \{/) }
    it { should contain_file('/etc/bind/named.conf.options').with_content(/8\.8\.8\.8;/) }
  end

end

