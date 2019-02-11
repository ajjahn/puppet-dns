require 'spec_helper'

describe 'Dns::Tsig', type: :define do
  let(:title) { 'ns3' }
  let(:pre_condition) { 'include dns::server' }
  # let(:post_condition) { 'include dns::server::service' }
  let :facts do
    {
      osfamily: 'Debian',
      concat_basedir: '/mock_dir',
    }
  end

  context 'passing valid array to server' do
    let :params do
      {
        server: ['192.168.0.1', '192.168.0.2'],
        algorithm: 'hmac-md5',
        secret: 'La/E5CjG9O+os1jq0a2jdA==',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include') }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(%r{key ns3\. \{}) }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(%r{server 192\.168\.0\.1}) }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(%r{server 192\.168\.0\.2}) }
  end

  context 'passing valid string to server' do
    let :params do
      {
        server: '192.168.0.1',
        algorithm: 'hmac-md5',
        secret: 'La/E5CjG9O+os1jq0a2jdA==',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include') }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(%r{key ns3\. \{}) }
    it { is_expected.to contain_concat__fragment('named.conf.local.tsig.ns3.include').with_content(%r{server 192\.168\.0\.1}) }
  end
end
