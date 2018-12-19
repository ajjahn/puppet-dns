require 'spec_helper'

describe 'dns::record::txt', type: :define do
  let(:title) { 'txttest' }
  let(:facts) { { concat_basedir: '/tmp' } }

  context 'passing a simple string should result in a quoted string' do
    let :params do
      {
        host: 'txttest',
        zone: 'example.com',
        data: 'testing',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.txttest,TXT,example.com.record').with_content(%r{^txttest\s+IN\s+TXT\s+"testing"$}) }
  end

  context 'passing a string that includes a quote character should result in the dns module escaping the quote' do
    let :params do
      {
        host: 'txttest',
        zone: 'example.com',
        data: 'this is a "test"',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.txttest,TXT,example.com.record').with_content(%r{^txttest\s+IN\s+TXT\s+"this is a \\"test\\""$}) }
  end

  context 'passing a long string should result in the dns module splitting that string into multiple quoted strings' do
    let :params do
      {
        host: 'txttest',
        zone: 'example.com',
        data: 'this is a ' + 'very ' * 60 + 'long test',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.txttest,TXT,example.com.record').with_content(%r{^txttest\s+IN\s+TXT\s+"this is a very.*" ".*very long test"$}) }
  end
end
