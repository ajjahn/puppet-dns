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

  context 'passing a string to forwarders' do
    let :params do
      { :forwarders => '8.8.8.8' }
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
    it { should contain_file('/etc/bind/named.conf.options').with_content(/allow-recursion {$/) }

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
      { :check_names_master => '8.8.8.8' }
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

end

