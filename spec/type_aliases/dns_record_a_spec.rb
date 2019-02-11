require 'spec_helper'

describe 'dns::record::a', type: :define do
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
        data: ['1.2.3.4'],
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,A,example.com.record')
        .with_content(%r{^foo\s+IN\s+A\s+1\.2\.3\.4$})
    }
  end
  context 'assigning a different host than the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: 'example.com',
        host: 'bar',
        data: ['1.2.3.4'],
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,A,example.com.record')
        .with_content(%r{^bar\s+IN\s+A\s+1\.2\.3\.4$})
    }
  end
end
