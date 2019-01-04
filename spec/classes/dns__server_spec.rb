require 'spec_helper'

describe 'dns::server' do
  context 'By Default' do
    let :facts do
      {
        osfamily: 'Debian',
        concat_basedir: '/dne',
      }
    end

    it { is_expected.to contain_class('dns::server::install') }
    it { is_expected.to contain_class('dns::server::config') }
    it { is_expected.to contain_class('dns::server::service') }
  end
end
