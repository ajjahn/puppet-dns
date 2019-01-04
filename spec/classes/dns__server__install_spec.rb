require 'spec_helper'

describe 'dns::server::install', type: :class do
  context 'on an unsupported OS' do
    it { is_expected.to raise_error(%r{/dns::server is incompatible with this osfamily/}) }
  end

  context 'on a Debian OS with default params' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end

    it { is_expected.to contain_class('dns::server::params') }
    ['bind9', 'dnssec-tools'].each do |package|
      it { is_expected.to contain_package(package).with('ensure' => 'latest') }
    end
  end

  context 'on a Debian OS with non-default params' do
    let :facts do
      {
        osfamily: 'Debian',
      }
    end
    let :params do
      {
        ensure_packages: 'present',
      }
    end

    it { is_expected.to contain_class('dns::server::params') }
    ['bind9', 'dnssec-tools'].each do |package|
      it { is_expected.to contain_package(package).with('ensure' => 'present') }
    end
  end

  context 'on a RedHat OS with default params' do
    let :facts do
      {
        osfamily: 'RedHat',
      }
    end

    it { is_expected.to contain_class('dns::server::params') }
    it { is_expected.to contain_package('bind').with('ensure' => 'latest') }
  end

  context 'on a RedHat OS with non-default params' do
    let :facts do
      {
        osfamily: 'RedHat',
      }
    end

    let :params do
      {
        ensure_packages: 'present',
      }
    end

    it { is_expected.to contain_class('dns::server::params') }
    it { is_expected.to contain_package('bind').with('ensure' => 'present') }
  end
end
