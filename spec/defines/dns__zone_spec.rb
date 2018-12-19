require 'spec_helper'

describe 'dns::zone' do
  let(:pre_condition) { 'include dns::server::params' }
  let(:title) { 'test.com' }
  let(:facts) { { osfamily: 'Debian', concat_basedir: '/mock_dir' } }

  describe 'passing something other than an array to $allow_query ' do
    let(:params) { { allow_query: '127.0.0.1' } }

    it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
  end

  describe 'passing an array to $allow_query' do
    let(:params) { { allow_query: ['192.0.2.0', '2001:db8::/32'] } }

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-query})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{192\.0\.2\.0;})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(/2001:db8::\/32/)
    }
  end

  describe 'passing something other than an array to $allow_transfer' do
    let(:params) { { allow_transfer: '127.0.0.1' } }

    it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
  end

  describe 'passing something other than an array to $allow_forwarder' do
    let(:params) { { allow_forwarder: '127.0.0.1' } }

    it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
  end

  describe 'passing an array to $allow_transfer and $allow_forwarder' do
    let(:params) do
      {
        allow_transfer: ['192.0.2.0', '2001:db8::/32'],
        allow_forwarder: ['8.8.8.8', '208.67.222.222'],
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-transfer})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{192\.0\.2\.0})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forwarders})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward first;})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{8.8.8.8})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(/2001:db8::\/32/)
    }
    it { is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage') }
    it {
      is_expected.to contain_concat__fragment('db.test.com.soa')
        .with_content(%r{_SERIAL_})
    }
    it {
      is_expected.to contain_exec('bump-test.com-serial')
        .with_refreshonly('true')
    }
  end

  context 'when ask to have a only forward policy' do
    let :params do
      { allow_transfer: [],
        allow_forwarder: ['8.8.8.8', '208.67.222.222'],
        forward_policy: 'only' }
    end

    it 'has a forward only policy' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward only;})
    end
  end

  context 'with no explicit forward policy or forwarder' do
    let(:params) { { allow_transfer: ['192.0.2.0', '2001:db8::/32'] } }

    it 'does not have any forwarder configuration' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward})
    end
  end

  context 'with a delegation-only zone' do
    let :params do
      { zone_type: 'delegation-only' }
    end

    it 'onlies have a type delegation-only entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{zone \"test.com\" \{\s*type delegation-only;\s*\}})
    end
  end

  context 'with a forward zone' do
    let :params do
      { allow_transfer: ['123.123.123.123'],
        allow_forwarder: ['8.8.8.8', '208.67.222.222'],
        forward_policy: 'only',
        zone_type: 'forward' }
    end

    it 'has a type forward entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{type forward})
    end
    it 'does not have allow_tranfer entry' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-transfer})
    end
    it 'does not have file entry' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{file})
    end
    it 'has a forward-policy entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward only})
    end
    it 'has a forwarders entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forwarders})
    end
    it 'has an "absent" zone file concat' do
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage').with(ensure: 'absent')
    end
  end

  context 'with a slave zone' do
    let :params do
      { slave_masters: ['123.123.123.123'],
        zone_type: 'slave' }
    end

    it 'has a type slave entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{type slave})
    end
    it 'has file entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{file})
    end
    it 'has masters entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{masters.*123.123.123.123 *;})
    end
    it 'does not have allow_tranfer entry' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-transfer})
    end
    it 'does not have any forward information' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward})
    end
    it 'has an "absent" zone file concat' do
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage').with(ensure: 'absent')
    end
  end

  context 'with a slave zone with multiple masters' do
    let :params do
      { slave_masters: ['123.123.123.123', '234.234.234.234'],
        zone_type: 'slave' }
    end

    it 'has masters entry with all masters joined by ;' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{masters.*123.123.123.123 *;[ \n]*234.234.234.234 *;})
    end
  end

  context 'with a stub zone' do
    let :params do
      { slave_masters: ['123.123.123.123'],
        zone_type: 'stub' }
    end

    it 'has a type stub entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{type stub})
    end
    it 'has file entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{file})
    end
    it 'has masters entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{masters.*123.123.123.123 *;})
    end
    it 'does not have allow_tranfer entry' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-transfer})
    end
    it 'does not have any forward information' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward})
    end
    it 'has an "absent" zone file concat' do
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage').with(ensure: 'absent')
    end
  end

  context 'with a stub zone with multiple masters' do
    let :params do
      { slave_masters: ['123.123.123.123', '234.234.234.234'],
        zone_type: 'stub' }
    end

    it 'has masters entry with all masters joined by ;' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{masters.*123.123.123.123 *;[ \n]*234.234.234.234 *;})
    end
  end

  context 'with a master zone' do
    let :params do
      { allow_transfer: ['8.8.8.8', '8.8.4.4'],
        allow_forwarder: ['8.8.8.8', '208.67.222.222'],
        forward_policy: 'only',
        zone_type: 'master' }
    end

    it 'has a type master entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{type master})
    end
    it 'has file entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{file})
    end
    it 'does not have masters entry' do
      is_expected.not_to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{masters})
    end
    it 'has allow_tranfer entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-transfer})
    end
    it 'has a forward-policy entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forward })
    end
    it 'has a forwarders entry' do
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{forwarders})
    end
    it 'has a zone file concat' do
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage').with(ensure: 'present')
    end
  end

  context 'passing no zone_notify setting' do
    let :params do
      {}
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').without_content(%r{ notify }) }
  end

  context 'passing a wrong zone_notify setting' do
    let :params do
      { zone_notify: 'maybe' }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The zone_notify}) }
  end

  context 'passing yes to zone_notify' do
    let :params do
      { zone_notify: 'yes' }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{ notify yes;}) }
  end

  context 'passing no to zone_notify' do
    let :params do
      { zone_notify: 'no' }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{ notify no;}) }
  end

  context 'passing master-only to zone_notify' do
    let :params do
      { zone_notify: 'master-only' }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{ notify master-only;}) }
  end

  context 'passing explicit to zone_notify' do
    let :params do
      { zone_notify: 'explicit' }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{ notify explicit;}) }
  end

  context 'passing no also_notify setting' do
    let :params do
      {}
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').without_content(%r{ also-notify }) }
  end

  context 'passing a string to also_notify' do
    let :params do
      { also_notify: '8.8.8.8' }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
  end

  context 'passing a valid array to also_notify' do
    let :params do
      { also_notify: ['8.8.8.8'] }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{ also-notify \{}) }
    it { is_expected.to contain_concat__fragment('named.conf.local.test.com.include').with_content(%r{8\.8\.8\.8;}) }
  end

  context 'passing true to reverse' do
    let(:title) { '10.23.45' }
    let :params do
      { reverse: true }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.10.23.45.include').with_content(%r{zone "10\.23\.45\.in-addr\.arpa"}) }
    it { is_expected.to contain_concat__fragment('db.10.23.45.soa').with_content(%r{\$ORIGIN\s+10\.23\.45\.in-addr\.arpa\.}) }
  end

  context 'passing reverse to reverse' do
    let(:title) { '10.23.45' }
    let :params do
      { reverse: 'reverse' }
    end

    it { is_expected.to contain_concat__fragment('named.conf.local.10.23.45.include').with_content(%r{zone "45\.23\.10\.in-addr\.arpa"}) }
    it { is_expected.to contain_concat__fragment('db.10.23.45.soa').with_content(%r{\$ORIGIN\s+45\.23\.10\.in-addr\.arpa\.}) }
  end

  describe 'passing something other than an array to $allow_update ' do
    let(:params) { { allow_update: '127.0.0.1' } }

    it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
  end

  describe 'passing an empty array to $allow_update' do
    let(:params) { { allow_update: [] } }

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage')
        .with(replace: true)
    }
  end

  describe 'passing an array to $allow_update' do
    let(:params) { { allow_update: ['192.0.2.0', '2001:db8::/32'] } }

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat('/var/lib/bind/zones/db.test.com.stage')
        .with(replace: false)
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{allow-update})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(%r{192\.0\.2\.0;})
    }
    it {
      is_expected.to contain_concat__fragment('named.conf.local.test.com.include')
        .with_content(/2001:db8::\/32/)
    }
  end
end
