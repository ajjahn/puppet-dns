require 'spec_helper'

describe 'Dns::Server::Options', type: :define do
  let(:pre_condition) { 'include ::dns::server' }
  let :facts do
    {
      osfamily: 'Debian',
      concat_basedir: '/tmp',
    }
  end
  let(:title) { '/etc/bind/named.conf.options' }

  context 'passing valid array to forwarders' do
    let :params do
      {
        forwarders: ['8.8.8.8', '4.4.4.4'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{8.8.8.8;$})
        .with_content(%r{4.4.4.4;$})
        .with_ensure('present')
        .with_owner('bind')
        .with_group('bind')
    }
  end

  context 'passing valid array to transfers' do
    let :params do
      {
        transfers: ['192.168.0.3', '192.168.0.4'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{192.168.0.3;$})
        .with_content(%r{192.168.0.4;$})
        .with_ensure('present')
        .with_owner('bind')
        .with_group('bind')
        .with_content(%r{allow-transfer})
    }
  end

  context 'passing a string to forwarders' do
    let :params do
      {
        forwarders: '8.8.8.8',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'passing a string to transfers' do
    let :params do
      {
        transfers: '192.168.0.3',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'passing valid array to listen_on' do
    let :params do
      {
        listen_on: ['10.11.12.13', '192.168.1.2'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{10.11.12.13;$})
        .with_content(%r{192.168.1.2;$})
    }
  end

  context 'passing custom port to listen_on_port' do
    let :params do
      {
        listen_on_port: 5300,
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{port 5300;}) }
  end

  context 'passing a string to listen_on' do
    let :params do
      {
        listen_on: '10.9.8.7',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'when passing valid array to listen_on_ipv6' do
    let :params do
      {
        listen_on_ipv6: ['2001:db8:1::1', '2001:db8:2::/124'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{2001:db8:1::1;$})
        .with_content(%r{2001:db8:2::/124;$})
    }
  end

  context 'when passing a string to listen_on_ipv6' do
    let :params do
      {
        listen_on_ipv6: '2001:db8:1::1',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'when the listen_on_ipv6 option is not provided' do
    let :params do
      {}
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{listen-on-v6 \{.+?any;.+?\}})
    }
  end

  context 'passing a string to recursion' do
    let :params do
      {
        allow_recursion: '8.8.8.8',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'passing a valid recursion allow range' do
    let :params do
      {
        allow_recursion: ['10.0.0.1'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{10.0.0.1;$})
        .with_content(%r{allow-recursion \{$})
    }
  end

  context 'passing a wrong string to slave name' do
    let :params do
      {
        check_names_slave: '8.8.8.8',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The check name policy}) }
  end

  context 'passing a wrong string to master name' do
    let :params do
      {
        check_names_master: '8.8.8.8',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The check name policy}) }
  end

  context 'passing a wrong string to response name' do
    let :params do
      {
        check_names_response: '8.8.8.8',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The check name policy}) }
  end

  context 'passing a valid string to a check name' do
    let :params do
      {
        check_names_master: 'warn',
        check_names_slave: 'ignore',
        check_names_response: 'warn',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{check-names master warn;})
        .with_content(%r{check-names slave ignore;$})
        .with_content(%r{check-names response warn;$})
    }
  end

  context 'passing no string to check name' do
    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .without_content(%r{check-names master})
        .without_content(%r{check-names slave})
        .without_content(%r{check-names response})
    }
  end

  context 'passing a string to the allow query' do
    let :params do
      {
        allow_query: '8.8.8.8',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'passing a valid array to the allow query' do
    let :params do
      {
        allow_query: ['8.8.8.8'],
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{8.8.8.8;})
        .with_content(%r{allow-query})
    }
  end

  context 'passing no statistic channel ip' do
    let :params do
      {}
    end

    it { is_expected.not_to contain_file('/etc/bind/named.conf.options').with_content(%r{statistics-channels}) }
  end

  context 'passing a valid ip and a valid port' do
    let :params do
      {
        statistic_channel_ip: '127.0.0.1',
        statistic_channel_port: '12455',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{statistics-channels}) }
    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{inet 127.0.0.1 port 12455;}) }
  end

  context 'passing no zone_notify setting' do
    let :params do
      {}
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').without_content(%r{^\s*notify }) }
  end

  context 'passing a wrong zone_notify setting' do
    let :params do
      {
        zone_notify: 'maybe',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The zone_notify}) }
  end

  context 'passing yes to zone_notify' do
    let :params do
      {
        zone_notify: 'yes',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{^\s*notify yes;}) }
  end

  context 'passing no to zone_notify' do
    let :params do
      {
        zone_notify: 'no',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{^\s*notify no;}) }
  end

  context 'passing master-only to zone_notify' do
    let :params do
      {
        zone_notify: 'master-only',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{^\s*notify master-only;})
    }
  end

  context 'passing explicit to zone_notify' do
    let :params do
      {
        zone_notify: 'explicit',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{^\s*notify explicit;}) }
  end

  context 'passing no also_notify setting' do
    let :params do
      {}
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').without_content(%r{^\s*also-notify }) }
  end

  context 'passing a string to also_notify' do
    let :params do
      {
        also_notify: '8.8.8.8',
      }
    end

    # it { is_expected.to raise_error(Puppet::Error, %r{is not an Array}) }
    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or Array}) }
  end

  context 'passing a valid array to also_notify' do
    let :params do
      {
        also_notify: ['8.8.8.8'],
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{^\s*also-notify \{}) }
    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{8\.8\.8\.8;}) }
  end

  context 'default value of dnssec_validation on RedHat 5' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemmajrelease: '5',
        concat_basedir: '/tmp',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .without_content(%r{dnssec-validation})
        .with_content(%r{dnssec-enable no})
    }
  end

  context 'default value of dnssec_validation on RedHat 6' do
    let :facts do
      {
        osfamily: 'RedHat',
        operatingsystemmajrelease: '6',
        concat_basedir: '/tmp',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{dnssec-validation auto})
        .with_content(%r{dnssec-enable yes})
    }
  end

  context 'default value of dnssec_validation on Debian' do
    let :facts do
      {
        osfamily: 'Debian',
        concat_basedir: '/tmp',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{dnssec-validation auto})
        .with_content(%r{dnssec-enable yes})
    }
  end

  context 'passing `false` to dnssec_enable' do
    let :params do
      {
        dnssec_enable: false,
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .without_content(%r{dnssec-validation})
        .with_content(%r{dnssec-enable no})
    }
  end

  context 'passing `absent` to dnssec_validation' do
    let :params do
      {
        dnssec_validation: 'absent',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .without_content(%r{dnssec-validation})
        .with_content(%r{dnssec-enable yes})
    }
  end

  context 'passing `auto` to dnssec_validation' do
    let :params do
      {
        dnssec_validation: 'auto',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{dnssec-validation auto})
        .with_content(%r{dnssec-enable yes})
    }
  end

  context 'passing `yes` to dnssec_validation' do
    let :params do
      {
        dnssec_validation: 'yes',
      }
    end

    it {
      is_expected.to contain_file('/etc/bind/named.conf.options')
        .with_content(%r{dnssec-validation yes})
        .with_content(%r{dnssec-enable yes})
    }
  end

  context 'passing `no` to dnssec_validation' do
    let :params do
      {
        dnssec_validation: 'no',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{dnssec-validation no}) }
  end
  context 'with not empty zone generation' do
    let :params do
      {
        no_empty_zones: true,
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{empty-zones-enable no}) }
  end

  context 'passing no notify_source' do
    let :params do
      {}
    end

    it { is_expected.not_to contain_file('/etc/bind/named.conf.options').with_content(%r{notify-source}) }
  end

  context 'passing notify_source a valid ip' do
    let :params do
      {
        notify_source: '127.0.0.1',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{notify-source 127.0.0.1;}) }
  end

  context 'passing notify_source an invalid string' do
    let :params do
      {
        notify_source: 'fooberry',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{is not an ip}) }
  end

  context 'passing no transfer_source' do
    let :params do
      {}
    end

    it { is_expected.not_to contain_file('/etc/bind/named.conf.options').with_content(%r{transfer-source}) }
  end

  context 'passing transfer_source a valid ip' do
    let :params do
      {
        transfer_source: '127.0.0.1',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{transfer-source 127.0.0.1;}) }
  end

  context 'passing transfer_source an invalid string' do
    let :params do
      {
        transfer_source: 'fooberry',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{is not an ip}) }
  end

  context 'passing a non-default data directory' do
    let :params do
      {
        data_dir: '/foo/bar',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{directory  *"/foo/bar"}) }
  end

  context 'passing a non-absolute data directory' do
    let :params do
      {
        data_dir: 'foo/bar',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{is not an absolute}) }
  end

  context 'passing a non-default working directory' do
    let :params do
      {
        working_dir: '/foo/bar',
        query_log_enable: true,
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{/foo/bar/named_querylog}) }
  end

  context 'passing a non-absolute working directory' do
    let :params do
      {
        working_dir: 'foo/bar',
        query_log_enable: true,
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{is not an absolute}) }
  end

  context 'not passing forward_policy' do
    it { is_expected.to contain_file('/etc/bind/named.conf.options').without_content(%r{ forward }) }
  end

  context 'passing forward_policy as `only`' do
    let :params do
      {
        forward_policy: 'only',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{ forward  *only *;}) }
  end

  context 'passing forward_policy as `first`' do
    let :params do
      {
        forward_policy: 'first',
      }
    end

    it { is_expected.to contain_file('/etc/bind/named.conf.options').with_content(%r{ forward  *first *;}) }
  end

  context 'passing forward_policy as an invalid string' do
    let :params do
      {
        forward_policy: 'snozberry',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{The forward_policy must be}) }
  end

  context 'passing forward_policy as an invalid type' do
    let :params do
      {
        forward_policy: ['first'],
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{expects a value of type Undef or String}) }
  end
end
