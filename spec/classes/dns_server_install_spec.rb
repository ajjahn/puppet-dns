require 'spec_helper'

describe 'dns::server::install', :type => :class do
  context "on an unknown OS" do
    it  { expect { subject }.to raise_error() }
  end

  context "on a Debian OS" do
    let :facts do
      {
        :osfamily               => 'Debian',
        :operatingsystemrelease => '6',
      }
    end
    it { should contain_package("bind9") }
  end

end

