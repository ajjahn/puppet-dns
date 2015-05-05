require 'spec_helper'

describe 'dns::zone' do
  let(:pre_condition) { 'include dns::server::params' }
  let(:title) { 'test.com' }
  let(:facts) {{ :osfamily => 'Debian', :concat_basedir => '/mock_dir' }}

  describe 'passing something other than an array to $allow_transfer' do
      let(:params) {{ :allow_transfer => '127.0.0.1' }}
      it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  describe 'passing something other than an array to $allow_forwarder' do
      let(:params) {{ :allow_forwarder => '127.0.0.1' }}
      it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  describe 'passing an array to $allow_transfer and $allow_forwarder' do
      let(:params) do {
          :allow_transfer => ['192.0.2.0', '2001:db8::/32'],
          :allow_forwarder => ['8.8.8.8', '208.67.222.222']
      }
      end
      it { should_not raise_error }
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
          with_content(/forwarders/)
      }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/forward first;/)
      }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/8.8.8.8/)
      }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/2001:db8::\/32/)
      }
      it { should contain_concat('/etc/bind/zones/db.test.com.stage') }
      it { should contain_concat__fragment('db.test.com.soa').
          with_content(/_SERIAL_/)
      }
      it { should contain_exec('bump-test.com-serial').
          with_refreshonly('true')
      }
  end

  context 'when ask to have a only forward policy' do
      let :params do
          { :allow_transfer => [],
            :allow_forwarder => ['8.8.8.8', '208.67.222.222'],
            :forward_policy => 'only'
          }
      end
      it 'should have a forward only policy' do
          should contain_concat__fragment('named.conf.local.test.com.include').
              with_content(/forward only;/)
      end
  end

  context 'with no explicit forward policy or forwarder' do
      let(:params) {{ :allow_transfer => ['192.0.2.0', '2001:db8::/32'] }}
      it 'should not have any forwarder configuration' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
              with_content(/forward/)
      end
  end

  context 'with a forward zone' do
      let :params do
          { :allow_transfer => ['123.123.123.123'],
            :allow_forwarder => ['8.8.8.8', '208.67.222.222'],
            :forward_policy => 'only',
            :zone_type => 'forward'
          }
      end
      it 'should have a type forward entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/type forward/)
      end
      it 'should not have allow_tranfer entry' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/allow-transfer/)
      end
      it 'should not have file entry' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/file/)
      end
      it 'should have a forward-policy entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/forward only/)
      end
      it 'should  have a forwarders entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/forwarders/)
      end
      it 'should have an "absent" zone file concat' do
          should contain_concat('/etc/bind/zones/db.test.com.stage').with({
              :ensure => "absent"
          })
      end
  end

  context 'with a slave zone' do
      let :params do
          { :slave_masters => ['123.123.123.123'],
            :zone_type => 'slave'
          }
      end
      it 'should have a type slave entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/type slave/)
      end
      it 'should have file entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/file/)
      end
      it 'should have masters entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/masters/)
      end
      it 'should not have allow_tranfer entry' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/allow-transfer/)
      end
      it 'should not have any forward information' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/forward/)
      end
      it 'should have an "absent" zone file concat' do
          should contain_concat('/etc/bind/zones/db.test.com.stage').with({
              :ensure => "absent"
          })
      end
  end

  context 'with a master zone' do
      let :params do
          { :allow_transfer => ['8.8.8.8','8.8.4.4'],
            :allow_forwarder => ['8.8.8.8', '208.67.222.222'],
            :forward_policy => 'only',
            :zone_type => 'master'
          }
      end
      it 'should have a type master entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/type master/)
      end
      it 'should have file entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/file/)
      end
      it 'should not have masters entry' do
          should_not contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/masters/)
      end
      it 'should have allow_tranfer entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/allow-transfer/)
      end
      it 'should have a forward-policy entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/forward /)
      end
      it 'should have a forwarders entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/forwarders/)
      end
      it 'should have a zone file concat' do
          should contain_concat('/etc/bind/zones/db.test.com.stage').with({
              :ensure => "present"
          })
      end
  end

end
