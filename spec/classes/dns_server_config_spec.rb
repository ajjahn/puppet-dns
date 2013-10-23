require 'spec_helper'

describe 'dns::server::config', :type => :class do

  context "on an unknown OS" do
    let :facts do { :concat_basedir  => '/dne', } end
    it  { expect { subject }.to raise_error() }
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

