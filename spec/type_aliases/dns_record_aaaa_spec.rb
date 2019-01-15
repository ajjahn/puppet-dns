require 'spec_helper'

describe 'dns::record::aaaa', type: :define do
  let(:pre_condition) { 'include ::dns::server' }
  let :facts do
    {
      concat_basedir: '/tmp',
    }
  end

  context 'letting the host be defined by the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: 'example.com',
        data: ['::1'],
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,AAAA,example.com.record')
        .with_content(%r{^foo\s+IN\s+AAAA\s+::1$})
    }
  end
  context 'assigning a different host than the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: 'example.com',
        host: 'bar',
        data: ['::1'],
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,AAAA,example.com.record')
        .with_content(%r{^bar\s+IN\s+AAAA\s+::1$})
    }
  end
end
