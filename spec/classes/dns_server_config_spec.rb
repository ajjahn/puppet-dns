require 'spec_helper'

RSpec.describe 'Dns::Server::Config', type: :class do
  let(:pre_condition) { 'include ::dns::server::install' }
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

  context 'on a Debian OS' do
    let :facts do
      {
        osfamily: 'Debian',
        os: { family: 'Debian' },
        operatingsystemrelease: '6',
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to contain_file('/etc/bind/').with_owner('bind') }
    it { is_expected.to contain_file('/etc/bind/named.conf').with_content(%r{^include "\/etc\/bind\/named.conf.options";$}) }
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        os: { family: 'RedHat' },
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to contain_file('/etc/named.conf').with_owner('named') }
    it { is_expected.to contain_file('/etc/named.conf').with_content(%r{^include "\/etc\/named\/named.conf.options";$}) }
  end
end
