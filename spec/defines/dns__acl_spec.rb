require 'spec_helper'

describe 'dns::acl' do
  let(:title) { 'trusted' }
  let(:facts) { {
    :concat_basedir => '/tmp',
    :osfamily       => 'Debian',
  } }

  context 'passing a string to data' do
    let :params do
      { :data => '192.168.0.0/24' }
    end
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing an array to data' do
    let :params do
      { :data => [ '192.168.0.0/24' ] }
    end
    it { should_not raise_error }
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

