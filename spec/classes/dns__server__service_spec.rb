require 'spec_helper'

describe 'Dns::Server::Service', type: :class do
  let :facts do
    {
      concat_basedir: '/mock_dir',
    }
  end

  context 'on a supported OS' do
    let :facts do
      {
        osfamily: 'Debian',
        os: { family: 'Debian' },
      }
    end

    it { is_expected.to contain_service('bind9').with_require('Class[Dns::Server::Config]') }
  end

  context 'on an unsupported OS' do
    let :facts do
      {
        osfamily: 'Solaris',
        os: { family: 'Solaris' },
      }
    end

    it { is_expected.to raise_error(Puppet::Error, %r{dns::server is incompatible with this osfamily: Solaris}) }
  end
end
