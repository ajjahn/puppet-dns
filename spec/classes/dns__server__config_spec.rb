require 'spec_helper'

describe 'dns::server::config', :type => :class do

  context "on an unsupported OS" do
    let :facts do { :osfamily => 'Solaris', :concat_basedir  => '/dne', } end
    it { should raise_error(/dns::server is incompatible with this osfamily/) }
  end

  context "on a Debian OS" do
    let (:facts) {{
      :osfamily               => 'Debian',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/dne',
    }}
    it { should contain_file('/etc/bind/').with_owner('bind') }
    it { should contain_file('/etc/bind/named.conf').with_content(/^include "\/etc\/bind\/named.conf.options";$/) }
  end

  context "on a RedHat OS" do
    let (:facts) {{
      :osfamily => 'RedHat',
      :concat_basedir => '/dne',
    }}
    it { should contain_file('/etc/named.conf').with_owner('named') }
    it { should contain_file('/etc/named.conf').with_content(/^include "\/etc\/named\/named.conf.options";$/) }
  end
end

