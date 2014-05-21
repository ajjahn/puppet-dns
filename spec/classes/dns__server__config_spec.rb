require 'spec_helper'

describe 'dns::server::config', :type => :class do

  context "on an unsupported OS" do
    let :facts do { :osfamily => 'Solaris', :concat_basedir  => '/dne', } end
    it { should raise_error(/dns::server is incompatible with this osfamily/) }
  end

  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
        :concat_basedir         => '/dne',
      }
    end

    it { should contain_file('/etc/bind/').with_owner('bind') }
  end

end

