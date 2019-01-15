require 'spec_helper'

describe 'dns::record::txt', type: :define do
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
        data: 'baz',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,TXT,example.com.record')
        .with_content(%r{^foo\s+IN\s+TXT\s+"baz"$})
    }
  end

  context 'assigning a different host than the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: 'example.com',
        host: 'bar',
        data: 'baz.example.com',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.foo,TXT,example.com.record')
        .with_content(%r{^bar\s+IN\s+TXT\s+"baz"$})
    }
  end
end
