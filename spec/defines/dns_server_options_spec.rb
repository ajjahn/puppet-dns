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

    it 'should fail input validation' do
      expect { subject }.to raise_error(Puppet::Error, /is not an Array/)
    end
  end

end

