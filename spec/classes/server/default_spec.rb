require 'spec_helper'

describe 'dns::server::default' do

  context "on an unsupported OS" do
    it{ should raise_error(/dns::server is incompatible with this osfamily/) }
  end

  context 'by default on debian' do

    let(:facts) {{ :osfamily => 'Debian', :concat_basedir => '/tmp' }}

    context "passing correct values and paths" do

      context 'passing `no` to resolvconf' do
        let(:params) {{ :resolvconf => 'no' }}
        it { should contain_file('/etc/default/bind9').with_content(/RESOLVCONF=no/) }
      end

      context 'passing `yes` to resolvconf' do
        let(:params) {{ :resolvconf => 'yes' }}
        it { should contain_file('/etc/default/bind9').with_content(/RESOLVCONF=yes/) }
      end

      context 'passing `-u bind -4` to options' do
        let(:params) {{ :options => '-u bind -4' }}
        it { should contain_file('/etc/default/bind9').with_content(/OPTIONS="-u bind -4"/) }
      end

      context 'passing `-u bind -6` to options' do
        let(:params) {{ :options => '-u bind -6' }}
        it { should contain_file('/etc/default/bind9').with_content(/OPTIONS="-u bind -6"/) }
      end

      context "requires bind9 and dnssec-tools package" do
        it do
          should contain_file('/etc/default/bind9').with({
            'require' => ['Package[bind9]', 'Package[dnssec-tools]'],
          })
        end
      end


    end

    context "passing wrong values and paths" do

      context 'passing wrong value to resolvconf for hit an error' do
        let(:params) {{ :resolvconf => 'WrongValue' }}
        it{ should raise_error(/The resolvconf value is not type of a string yes \/ no./)}
      end

    end

  end

  context 'by default on redhat' do

    let(:facts) {{ :osfamily => 'RedHat', :concat_basedir => '/tmp' }}

    context "passing correct values and paths" do

      context 'passing path `/chroot` to rootdir' do
        let(:params) {{ :rootdir => '/chroot' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ROOTDIR="\/chroot"/) }
      end

      context 'passing `-u named` to options' do
        let(:params) {{ :options => '-u named' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/OPTIONS="-u named"/) }
      end

      context 'passing `yes` to enable_zone_write' do
        let(:params) {{ :enable_zone_write => 'yes' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_ZONE_WRITE=yes/) }
      end

      context 'passing `no` to enable_zone_write' do
        let(:params) {{ :enable_zone_write => 'no' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_ZONE_WRITE=no/) }
      end

      context 'passing `yes` to enable_sdb' do
        let(:params) {{ :enable_sdb => 'yes' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_SDB=yes/) }
      end

      context 'passing `no` to enable_sdb' do
        let(:params) {{ :enable_sdb => 'no' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_SDB=no/) }
      end

      context 'passing `1` to enable_sdb' do
        let(:params) {{ :enable_sdb => '1' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_SDB=1/) }
      end

      context 'passing `0` to enable_sdb' do
        let(:params) {{ :enable_sdb => '0' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/ENABLE_SDB=0/) }
      end

      context 'passing `yes` to disable_named_dbus' do
        let(:params) {{ :disable_named_dbus => 'yes' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/DISABLE_NAMED_DBUS=yes/) }
      end

      context 'passing `no` to disable_named_dbus' do
        let(:params) {{ :disable_named_dbus => 'no' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/DISABLE_NAMED_DBUS=no/) }
      end

      context 'passing path `/usr/local/samba/private/dns.keytab` to keytab_file' do
        let(:params) {{ :keytab_file => '/usr/local/samba/private/dns.keytab' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/KEYTAB_FILE="\/usr\/local\/samba\/private\/dns.keytab/) }
      end

      context 'passing `yes` to disable_zone_checking' do
        let(:params) {{ :disable_zone_checking => 'yes' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/DISABLE_ZONE_CHECKING=yes/) }
      end

      context 'passing `no` to disable_zone_checking' do
        let(:params) {{ :disable_zone_checking => 'no' }}
        it { should contain_file('/etc/sysconfig/named').with_content(/DISABLE_ZONE_CHECKING=no/) }
      end

      context "requires bind package" do
        it do
          should contain_file('/etc/sysconfig/named').with({
            'require' => 'Package[bind]',
          })
        end
      end

    end

    context "passing wrong values and paths" do

      context 'passing wrong value to rootdir for hit an error' do
        let(:params) {{ :rootdir => 'chroot' }}
        it{ should raise_error(/"chroot" is not an absolute path./)}
      end

      context 'passing wrong value to enable_zone_write for hit an error' do
        let(:params) {{ :enable_zone_write => 'WrongValue' }}
        it{ should raise_error(/The enable_zone_write value is not type of a string yes \/ no./)}
      end

      context 'passing wrong value to enable_sdb for hit an error' do
        let(:params) {{ :enable_sdb => 'WrongValue' }}
        it{ should raise_error(/The enable_sdb value is not type of a string yes \/ no \/ 1 \/ 0 or empty./)}
      end

      context 'passing wrong value to keytab_file for hit an error' do
        let(:params) {{ :keytab_file => 'usr/local/samba/private/dns.keytab' }}
        it{ should raise_error(/"usr\/local\/samba\/private\/dns.keytab" is not an absolute path./)}
      end

      context 'passing wrong value to disable_zone_checking for hit an error' do
        let(:params) {{ :disable_zone_checking => 'chroot' }}
        it{ should raise_error(/The disable_zone_checking value is not type of a string yes \/ no or empty./)}
      end

    end

  end

end
