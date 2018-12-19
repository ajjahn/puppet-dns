require 'spec_helper'

describe 'dns::server::service' do
  let(:facts) { { concat_basedir: '/mock_dir' } }

  context 'on a supported OS' do
    let(:facts) { { osfamily: 'Debian' } }

    it { is_expected.to contain_service('bind9').with_require('Class[Dns::Server::Config]') }
  end

  context 'on an unsupported OS' do
    let(:facts) { { osfamily: 'Solaris' } }

    it { is_expected.to raise_error(%r{dns::server is incompatible with this osfamily: Solaris}) }
  end
end
