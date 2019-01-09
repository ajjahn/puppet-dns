require 'spec_helper'

describe 'Dns::Server::Config', type: :class do
  context 'on an unsupported OS' do
    let :facts do
      {
        osfamily: 'Solaris',
        os: { family: 'Solaris' },
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to raise_error(%r{dns::server is incompatible with this osfamily}) }
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

    it {
      is_expected.to contain_file('/etc/bind/')
        .with_owner('bind')
        .with_content(%r{^include "\/etc\/bind\/named.conf.options";$})
    }
  end

  context 'on a RedHat OS' do
    let :facts do
      {
        osfamily: 'RedHat',
        os: { family: 'RedHat' },
        concat_basedir: '/dne',
      }
    end

    it {
      is_expected.to contain_file('/etc/named.conf')
        .with_owner('named')
        .with_content(%r{^include "\/etc\/named\/named.conf.options";$})
    }
  end
end
