require 'spec_helper'

describe 'Dns::Server::Default', type: :class do
  let(:pre_condition) { 'include ::dns::server::params' }
  let(:post_condition) { 'include ::dns::server::service' }

  context 'on an unsupported OS' do
    let :facts do
      {
        osfamily: 'Solaris',
        os: { family: 'Solaris' },
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{dns::server is incompatible with this osfamily}) }
  end
  context 'by default on debian' do
    let :facts do
      {
        osfamily: 'Debian',
        os: { family: 'Debian' },
        concat_basedir: '/tmp',
      }
    end

    context 'passing correct values and paths' do
      context 'passing `no` to resolvconf' do
        let :params do
          {
            resolvconf: 'no',
          }
        end

        it { is_expected.to contain_file('/etc/default/bind9').with_content(%r{RESOLVCONF=no}) }
      end
      context 'passing `yes` to resolvconf' do
        let :params do
          {
            resolvconf: 'yes',
          }
        end

        it { is_expected.to contain_file('/etc/default/bind9').with_content(%r{RESOLVCONF=yes}) }
      end
      context 'passing `-u bind -4` to options' do
        let :params do
          {
            options: '-u bind -4',
          }
        end

        it { is_expected.to contain_file('/etc/default/bind9').with_content(%r{OPTIONS='-u bind -4'}) }
      end
      context 'passing `-u bind -6` to options' do
        let :params do
          {
            options: '-u bind -6',
          }
        end

        it { is_expected.to contain_file('/etc/default/bind9').with_content(%r{OPTIONS='-u bind -6'}) }
      end
      context 'requires bind9 and dnssec-tools package' do
        it { is_expected.to contain_file('/etc/default/bind9').with('require' => ['Package[bind9]', 'Package[dnssec-tools]']) }
      end
    end
    context 'passing wrong values and paths' do
      context 'passing wrong value to resolvconf for hit an error' do
        let :params do
          {
            resolvconf: 'WrongValue',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{The resolvconf value is not type of a string yes \/ no.}) }
      end
    end
  end
  context 'by default on redhat' do
    let :facts do
      {
        osfamily: 'RedHat',
        concat_basedir: '/tmp',
      }
    end

    context 'passing correct values and paths' do
      context 'passing path `/chroot` to rootdir' do
        let :params do
          {
            rootdir: '/chroot',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ROOTDIR='/chroot'}) }
      end
      context 'passing `-u named` to options' do
        let :params do
          {
            options: '-u named',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{OPTIONS='-u named'}) }
      end
      context 'passing `yes` to enable_zone_write' do
        let :params do
          {
            enable_zone_write: 'yes',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_ZONE_WRITE=yes}) }
      end
      context 'passing `no` to enable_zone_write' do
        let :params do
          {
            enable_zone_write: 'no',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_ZONE_WRITE=no}) }
      end
      context 'passing `yes` to enable_sdb' do
        let :params do
          {
            enable_sdb: 'yes',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_SDB=yes}) }
      end
      context 'passing `no` to enable_sdb' do
        let :params do
          {
            enable_sdb: 'no',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_SDB=no}) }
      end
      context 'passing `1` to enable_sdb' do
        let :params do
          {
            enable_sdb: '1',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_SDB=1}) }
      end
      context 'passing `0` to enable_sdb' do
        let :params do
          {
            enable_sdb: '0',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{ENABLE_SDB=0}) }
      end
      context 'passing `yes` to disable_named_dbus' do
        let :params do
          {
            disable_named_dbus: 'yes',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{DISABLE_NAMED_DBUS=yes}) }
      end
      context 'passing `no` to disable_named_dbus' do
        let :params do
          {
            disable_named_dbus: 'no',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{DISABLE_NAMED_DBUS=no}) }
      end
      context 'passing path `/usr/local/samba/private/dns.keytab` to keytab_file' do
        let :params do
          {
            keytab_file: '/usr/local/samba/private/dns.keytab',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{KEYTAB_FILE='/usr/local/samba/private/dns.keytab}) }
      end
      context 'passing `yes` to disable_zone_checking' do
        let :params do
          {
            disable_zone_checking: 'yes',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{DISABLE_ZONE_CHECKING=yes}) }
      end
      context 'passing `no` to disable_zone_checking' do
        let :params do
          {
            disable_zone_checking: 'no',
          }
        end

        it { is_expected.to contain_file('/etc/sysconfig/named').with_content(%r{DISABLE_ZONE_CHECKING=no}) }
      end
      context 'requires bind package' do
        it { is_expected.to contain_file('/etc/sysconfig/named').with('require' => 'Package[bind]') }
      end
    end
    context 'passing wrong values and paths' do
      context 'passing wrong value to rootdir for hit an error' do
        let :params do
          {
            rootdir: 'chroot',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{/'chroot' is not an absolute path./}) }
      end
      context 'passing wrong value to enable_zone_write for hit an error' do
        let :params do
          {
            enable_zone_write: 'WrongValue',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{The enable_zone_write value is not type of a string yes \/ no.}) }
      end
      context 'passing wrong value to enable_sdb for hit an error' do
        let :params do
          {
            enable_sdb: 'WrongValue',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{The enable_sdb value is not type of a string yes \/ no \/ 1 \/ 0 or empty.}) }
      end
      context 'passing wrong value to keytab_file for hit an error' do
        let :params do
          {
            keytab_file: 'usr/local/samba/private/dns.keytab',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{'/usr/local/samba/private/dns.keytab' is not an absolute path.}) }
      end
      context 'passing wrong value to disable_zone_checking for hit an error' do
        let :params do
          {
            disable_zone_checking: 'chroot',
          }
        end

        it { is_expected.to raise_error(Puppet::Error, %r{The disable_zone_checking value is not type of a string yes \/ no or empty.}) }
      end
    end
  end
end
