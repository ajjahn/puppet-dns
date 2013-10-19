require 'spec_helper'

describe 'dns::acl' do
  let(:title) { 'trusted' }

  context 'passing a string to data' do
    let :facts do { :concat_basedir => '/dne',  } end
    let :params do
      { :data => '192.168.0.0/24' }
    end

    it 'should fail input validation' do
      expect { subject }.to raise_error(Puppet::Error, /is not an Array/)
    end
  end

  context 'passing an array to data' do
    let :facts do { :concat_basedir => '/dne',  } end
    let :params do
      { :data => [ '192.168.0.0/24' ] }
    end

    it 'should pass input validation' do
      expect { subject }.to_not raise_error
    end

    it {
      should contain_concat__fragment('named.conf.local.acl.trusted.include').
      with_content(/acl trusted/)
    }

    it {
      should contain_concat__fragment('named.conf.local.acl.trusted.include').
      with_content(/192.168.0.0\/24;/)
    }

  end

end

