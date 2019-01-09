require 'spec_helper'

describe 'Dns::Server', type: :class do
  context 'By Default' do
    let :facts do
      {
        osfamily: 'Debian',
        os: { family: 'Debian' },
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to contain_class('dns::server::install') }
    it { is_expected.to contain_class('dns::server::config') }
    it { is_expected.to contain_class('dns::server::service') }
  end
end
