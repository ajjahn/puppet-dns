require 'spec_helper'

describe 'dns::zone' do
  let(:title) { 'test.com' }

  context 'passing something other than an array' do
    let :facts  do { :osfamily => 'Debian', :concat_basedir => '/dne' } end
    let :params do { :allow_transfer => '127.0.0.1' } end

    it 'should fail input validation' do
      expect { subject }.to raise_error(Puppet::Error, /is not an Array/)
    end
  end

  context 'passing an array to data' do
    let :facts  do { :osfamily => 'Debian', :concat_basedir => '/dne' } end
    let :params do
      { :allow_transfer => [ '192.0.2.0', '2001:db8::/32' ] }
    end

    it 'should pass input validation' do
      expect { subject }.to_not raise_error
    end

    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
      with_content(/allow-transfer/)
    }

    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
      with_content(/192\.0\.2\.0/)
    }
    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
      with_content(/2001:db8::\/32/)
    }

    it { 
      should contain_concat('/etc/bind/zones/db.test.com.stage')
    }

    it { should contain_concat__fragment('db.test.com.soa').
      with_content(/_SERIAL_/)
    }

    it {
      should contain_exec('bump-test.com-serial').
      with_refreshonly('true')
    }

  end

end

