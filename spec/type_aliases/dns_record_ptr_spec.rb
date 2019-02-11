require 'spec_helper'

describe 'dns::record::ptr', type: :define do
  let(:pre_condition) { 'include ::dns::server' }
  let :facts do
    {
      concat_basedir: '/tmp',
    }
  end

  context 'letting the host be defined by the resource name' do
    let(:title) { '1' }
    let :params do
      {
        zone: '0.0.127.in-addr.arpa',
        data: 'localhost',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.0.0.127.in-addr.arpa.1,PTR,0.0.127.in-addr.arpa.record')
        .with_content(%r{^1\s+IN\s+PTR\s+localhost\.$})
    }
  end
  context 'assigning a different host than the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: '0.0.127.in-addr.arpa',
        host: '1',
        data: 'localhost',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.0.0.127.in-addr.arpa.foo,PTR,0.0.127.in-addr.arpa.record')
        .with_content(%r{^1\s+IN\s+PTR\s+localhost\.$})
    }
  end
end
