require 'spec_helper'

describe 'dns::zone' do
  let(:pre_condition) { 'include dns::server::params' }
  let(:title) { 'test.com' }

  context 'on a supported operating system' do
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
      
      context 'when ask to have supplementary zone' do
          let :params do {
              :supplementary => true
          }
          end

          it {
              should contain_file('/etc/bind/zones/db.test.com.supplementary').with({
                  'ensure' => 'present',
                  'replace' => 'no',
              }).with_content(/; Supplementary file from Puppet/)
          }
      end

      context 'when not asked to have supplementary zone' do
          let :params do {
              :ensure => 'absent'
          }
          end

          it {
              should contain_file('/etc/bind/zones/db.test.com.supplementary').with({
                  'ensure' => 'absent',
              })
          }
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
                         with_content(/allow_transfer/)
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
      end
  end
end

