require 'spec_helper'

describe 'dns::record::ns', :type => :define do
  let(:title) { 'example.com' }
  let(:facts) { { :concat_basedir => '/dne' } }

  context 'passing an implicit host' do
    let :params do {
        :zone => 'example.com',
        :data => 'ns3'
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.example.com,example.com,NS,ns3.record').with_content(/^example.com\s+IN\s+NS\s+ns3$/) }
  end

  context 'passing an explicit host' do
    let :params do {
        :zone       => 'example.com',
        :host       => 'delegated-zone',
        :data       => 'ns4.jp.example.net.'
    } end
    it { should_not raise_error }
    it { should contain_concat__fragment('db.example.com.delegated-zone,example.com,NS,ns4.jp.example.net..record').with_content(/^delegated-zone\s+IN\s+NS\s+ns4.jp.example.net\.$/) }
  end

  context 'passing a wrong (numeric top-level domain) zone' do
    let :params do {
        :zone => 'six.022',
        :data => 'avogadro.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing a wrong (numeric) zone' do
    let :params do {
        :zone => 789,
        :data => 'badzone.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing a wrong (IP address) zone' do
    let :params do {
        :zone => '192.168.2.1',
        :data => 'ipaddrzone.example.com'
    } end
    it { should raise_error(Puppet::Error, /must be a valid domain name/) }
  end

  context 'passing wrong (numeric) data' do
    let :params do {
        :zone => 'example.com',
        :data => 443
    } end
    it { should raise_error(Puppet::Error, /must be a valid hostname/) }
  end

  context 'passing wrong (IP address) data' do
    let :params do {
        :zone => 'example.com',
        :data => '192.168.4.5'
    } end
    it { should raise_error(Puppet::Error, /must be a valid hostname/) }
  end
end

