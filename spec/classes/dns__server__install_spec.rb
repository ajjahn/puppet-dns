require 'spec_helper'

describe 'dns::server::install', type: :class do
  context 'on an unsupported OS' do
    it { is_expected.to raise_error(%r{dns::server is incompatible with this osfamily}) }
  end

  context 'on a Debian OS with default params' do
    let(:facts) { { osfamily: 'Debian' } }

    it { is_expected.to contain_class('dns::server::params') }
    ['bind9', 'dnssec-tools'].each do |package|
      it do
        is_expected.to contain_package(package).with('ensure' => 'latest')
      end
    end
  end

  context 'on a Debian OS with non-default params' do
    let(:facts)  { { osfamily: 'Debian' } }
    let(:params) { { ensure_packages: 'present' } }

    it { is_expected.to contain_class('dns::server::params') }
    ['bind9', 'dnssec-tools'].each do |package|
      it do
        is_expected.to contain_package(package).with('ensure' => 'present')
      end
    end
  end

  context 'on a RedHat OS with default params' do
    let(:facts) { { osfamily: 'RedHat' } }

    it { is_expected.to contain_class('dns::server::params') }
    it do
      is_expected.to contain_package('bind').with('ensure' => 'latest')
    end
  end

  context 'on a RedHat OS with non-default params' do
    let(:facts)  { { osfamily: 'RedHat' } }
    let(:params) { { ensure_packages: 'present' } }

    it { is_expected.to contain_class('dns::server::params') }
    it do
      is_expected.to contain_package('bind').with('ensure' => 'present')
    end
  end
end
