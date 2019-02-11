require 'spec_helper'

describe 'Dns::Record::A', type: :define do
  let(:title) { 'atest' }
  let(:pre_condition) { 'include ::dns::server' }
  let :facts do
    {
      concat_basedir: '/tmp',
    }
  end

  context 'passing a single ip address with ptr=>false' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: '192.168.128.42',
        ptr: 'false',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.42$}) }
    it { is_expected.not_to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record') }
  end

  context 'passing a single ip address with ptr=>true' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: '192.168.128.42',
        ptr: 'true',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.42$}) }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^42\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing a single ip address with ptr=>all' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: '192.168.128.42',
        ptr: 'all',
      }
    end

    it { is_expected.not_to raise_error }
    it { is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record').with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.42$}) }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.42.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^42\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing multiple ip addresses with ptr=>false' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'false',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record')
        .with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$})
    }
    it { is_expected.not_to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record') }
  end

  context 'passing multiple ip addresses with ptr=>true' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'true',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record')
        .with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$})
    }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing multiple ip addresses with ptr=>all' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.example.com.atest,A,example.com.record')
        .with_content(%r{^atest\s+IN\s+A\s+192\.168\.128\.68\natest\s+IN\s+A\s+192\.168\.128\.69\natest\s+IN\s+A\s+192\.168\.128\.70$})
    }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.69.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^69\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.70.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^70\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class A network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let(:pre_condition) do
      [
        'include ::dns::server',
        'dns::zone { "192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\.128\.168\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class B network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let(:pre_condition) do
      [
        'include ::dns::server',
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class C network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end

    let(:pre_condition) do
      [
        'include ::dns::server',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class A and class B network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let(:pre_condition) do
      [
        'include ::dns::server',
        'dns::zone { "192.IN-ADDR.ARPA": }',
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\.128\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class A and class C network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let :pre_condition do
      [
        'include ::dns::server',
        'dns::zone { "192.IN-ADDR.ARPA": }',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class B and class C network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let :pre_condition do
      [
        'include ::dns::server',
        'dns::zone { "168.192.IN-ADDR.ARPA": }',
        'dns::zone { "128.168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end

  context 'passing ptr=>true with class A, class B and class C network defined' do
    let :params do
      {
        host: 'atest',
        zone: 'example.com',
        data: ['192.168.128.68', '192.168.128.69', '192.168.128.70'],
        ptr: 'all',
      }
    end
    let :pre_condition do
      [
        'include ::dns::server',
        'dns::zone{ "192.IN-ADDR.ARPA": }',
        'dns::zone{ "168.192.IN-ADDR.ARPA": }',
        'dns::zone{ "128.168.192.IN-ADDR.ARPA": }',
      ]
    end

    it { is_expected.not_to raise_error }
    it {
      is_expected.to contain_concat__fragment('db.128.168.192.IN-ADDR.ARPA.68.128.168.192.IN-ADDR.ARPA,PTR,128.168.192.IN-ADDR.ARPA.record')
        .with_content(%r{^68\s+IN\s+PTR\s+atest\.example\.com\.$})
    }
  end
end
