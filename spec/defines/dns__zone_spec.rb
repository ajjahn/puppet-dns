require 'spec_helper'

describe 'dns::zone' do
  let(:pre_condition) { 'include dns::server::params' }
  let(:title) { 'test.com' }
  let(:facts) {{ :osfamily => 'Debian', :concat_basedir => '/mock_dir' }}

  describe 'passing camelcase name zone than lowercase name zone to $title ' do
      let(:title)  { 'TeSt.cOm' }
      it { should raise_error(/must be lowercase/) }
  end

  describe 'passing uppercase name zone than lowercase name zone to $title ' do
      let(:title)  { 'TEST.COM' }
      it { should raise_error(/must be lowercase/) }
  end

  describe 'passing something other than an array to $allow_query ' do
      let(:params) {{ :allow_query => '127.0.0.1' }}
      it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  describe 'passing an array to $allow_query' do 
      let(:params) {{ :allow_query => ['192.0.2.0', '2001:db8::/32'] }}
      it { should_not raise_error }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/allow-query/)
      }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/192\.0\.2\.0;/)
      }
      it {
          should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/2001:db8::\/32/)
      }
  end

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

  context 'with a delegation-only zone' do
      let :params do
          { :zone_type => 'delegation-only'
          }
      end
      it 'should only have a type delegation-only entry' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                     with_content(/zone \"test.com\" \{\s*type delegation-only;\s*\}/)
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
                         with_content(/masters.*123.123.123.123 *;/)
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

  context 'with a slave zone with multiple masters' do
      let :params do
          { :slave_masters => ['123.123.123.123', '234.234.234.234'],
            :zone_type => 'slave'
          }
      end
      it 'should have masters entry with all masters joined by ;' do
          should contain_concat__fragment('named.conf.local.test.com.include').
                         with_content(/masters.*123.123.123.123 *;[ \n]*234.234.234.234 *;/)
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

  context 'passing no zone_notify setting' do
    let :params do
      {}
    end
    it { should contain_concat__fragment('named.conf.local.test.com.include').without_content(/ notify /) }
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
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify yes;/) }
  end

  context 'passing no to zone_notify' do
    let :params do
      { :zone_notify => 'no' }
    end
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify no;/) }
  end

  context 'passing master-only to zone_notify' do
    let :params do
      { :zone_notify => 'master-only' }
    end
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify master-only;/) }
  end

  context 'passing explicit to zone_notify' do
    let :params do
      { :zone_notify => 'explicit' }
    end
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ notify explicit;/) }
  end

  context 'passing no also_notify setting' do
    let :params do
      {}
    end
    it { should contain_concat__fragment('named.conf.local.test.com.include').without_content(/ also-notify /) }
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
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/ also-notify \{/) }
    it { should contain_concat__fragment('named.conf.local.test.com.include').with_content(/8\.8\.8\.8;/) }
  end

  describe 'passing "192.168.notcorrect" to $title with reverse=>"reverse" ' do
    let(:title)  { '192.168.notcorrect' }
    let :params do
      { :reverse => 'reverse' }
    end
    it { should raise_error(/Name zone with parameter reverse /) }
  end

  describe 'passing "168.192.notcorrect" to $title with reverse=>true ' do
    let(:title)  { '168.192.notcorrect' }
    let :params do
      { :reverse => true }
    end
    it { should raise_error(/Name zone with parameter reverse /) }
  end

  describe 'passing "notcorrect.168.192.in-addr.arpa" to $title with reverse=>false ' do
    let(:title)  { 'notcorrect.168.192.in-addr.arpa' }
    let :params do
      { :reverse => false }
    end
    it { should raise_error(/Name zone with parameter reverse /) }
  end

  describe 'passing "192.168" to $title with reverse=>"reverse" and pre_condition dns::zone{ "168.192.in-addr.arpa": reverse => false } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": reverse => false, }',
    ] end
    let(:title)  { '192.168' }
    let :params do
      { :reverse => 'reverse' }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing "192.168" to $title with reverse=>"reverse" and pre_condition dns::zone{ "168.192": reverse => true } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
    ] end
    let(:title)  { '192.168' }
    let :params do
      { :reverse => 'reverse' }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing "168.192" to $title with reverse=>true and pre_condition dns::zone{ "168.192.in-addr.arpa": reverse => false } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "168.192.in-addr.arpa": reverse => false, }',
    ] end
    let(:title)  { '168.192' }
    let :params do
      { :reverse => true }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing "168.192" to $title with reverse=>true and pre_condition dns::zone{ "192.168": reverse => "reverse" } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    let(:title)  { '168.192' }
    let :params do
      { :reverse => true }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing "168.192.in-addr.arpa" to $title with reverse=>false and pre_condition dns::zone{ "168.192": reverse => true } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "168.192": reverse => true, }',
    ] end
    let(:title)  { '168.192.in-addr.arpa' }
    let :params do
      { :reverse => false }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing "168.192.in-addr.arpa" to $title with reverse=>false and pre_condition dns::zone{ "192.168": reverse => "reverse" } (Twin zones)' do
    let :pre_condition do [
        'dns::zone { "192.168": reverse => "reverse", }',
    ] end
    let(:title)  { '168.192.in-addr.arpa' }
    let :params do
      { :reverse => false }
    end
    it { should raise_error(Puppet::Error, /Duplicate declaration\: Exec\[bump-168\.192\.in-addr\.arpa-serial\] is already declared in file/)}
  end

  describe 'passing something other than an array to $allow_query ' do
      let(:params) {{ :allow_query => '127.0.0.1' }}
      it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  context 'passing true to reverse' do
    let(:title) { '10.23.45' }
    let :params do
      { :reverse => true }
    end
    it { should contain_concat__fragment('named.conf.local.10.23.45.include').with_content(/zone "10\.23\.45\.in-addr\.arpa"/) }
    it { should contain_concat__fragment('db.10.23.45.soa').with_content(/\$ORIGIN\s+10\.23\.45\.in-addr\.arpa\./) }
  end

  context 'passing reverse to reverse' do
    let(:title) { '10.23.45' }
    let :params do
      { :reverse => 'reverse' }
    end
    it { should contain_concat__fragment('named.conf.local.10.23.45.include').with_content(/zone "45\.23\.10\.in-addr\.arpa"/) }
    it { should contain_concat__fragment('db.10.23.45.soa').with_content(/\$ORIGIN\s+45\.23\.10\.in-addr\.arpa\./) }
  end

  describe 'passing something other than an array to $allow_update ' do
    let(:params) {{ :allow_update => '127.0.0.1' }}
    it { should raise_error(Puppet::Error, /is not an Array/) }
  end

  describe 'passing an empty array to $allow_update' do
    let(:params) {{ :allow_update => [] }}
    it { should_not raise_error }
    it {
      should contain_concat('/etc/bind/zones/db.test.com.stage').
          with({ :replace => true })
    }
  end

  describe 'passing an array to $allow_update' do
    let(:params) {{ :allow_update => ['192.0.2.0', '2001:db8::/32'] }}
    it { should_not raise_error }
    it {
      should contain_concat('/etc/bind/zones/db.test.com.stage').
                 with({ :replace => false })
    }
    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/allow-update/)
    }
    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/192\.0\.2\.0;/)
    }
    it {
      should contain_concat__fragment('named.conf.local.test.com.include').
          with_content(/2001:db8::\/32/)
    }
  end
end

