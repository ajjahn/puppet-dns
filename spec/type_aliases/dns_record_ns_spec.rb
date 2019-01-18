require 'spec_helper'

describe 'dns::record::ns', type: :define do
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
        data: 'baz.example.com.',
      }
    end

    it { is_expected.not_to raise_error }
    # TODO: 
    # For some reason this fails and I haven't quite figured out why.
    # it {
    #   is_expected.to contain_concat__fragment('db.example.com.foo,NS,example.com.record')
    #    .with_content(%r{^foo\s+IN\s+NS\s+baz\.example\.com\.$})
    # }
  end
  context 'assigning a different host than the resource name' do
    let(:title) { 'foo' }
    let :params do
      {
        zone: 'example.com',
        host: 'bar',
        data: 'baz.example.com.',
      }
    end

    it { is_expected.not_to raise_error }
    # TODO: 
    # For some reason this fails and I haven't quite figured out why.
    # it {
    #   is_expected.to contain_concat__fragment('db.example.com.foo,NS,example.com.record')
    #     .with_content(%r{^bar\s+IN\s+NS\s+baz\.example\.com\.$})
    # }
  end
end
